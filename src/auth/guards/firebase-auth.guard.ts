import { CanActivate, ExecutionContext, Injectable, UnauthorizedException } from '@nestjs/common';
import { Request } from 'express';
import { DecodedIdToken } from 'firebase-admin/auth';
import { FirebaseAdminService } from '../firebase-admin.service';

export interface AuthenticatedRequest extends Request {
  user: DecodedIdToken;
}

@Injectable()
export class FirebaseAuthGuard implements CanActivate {
  constructor(private readonly firebaseAdminService: FirebaseAdminService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<AuthenticatedRequest>();

    const authorization = request.headers.authorization;

    if (!authorization?.startsWith('Bearer ')) {
      throw new UnauthorizedException('Missing or invalid authorization header');
    }

    const idToken = authorization.substring(7);

    if (!idToken) {
      throw new UnauthorizedException('Missing Firebase ID token');
    }

    try {
      const decodedToken = await this.firebaseAdminService.getAuth().verifyIdToken(idToken);

      request.user = decodedToken;

      return true;
    } catch {
      throw new UnauthorizedException('Invalid Firebase ID token');
    }
  }
}
