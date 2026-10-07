import { Controller, Get, Req, UseGuards } from '@nestjs/common';
import type { AuthenticatedRequest } from './guards/firebase-auth.guard';
import { FirebaseAuthGuard } from './guards/firebase-auth.guard';
import { AuthService } from './auth.service';
import { UserResponseMapper } from '../users/mappers/user-response.mapper';
import type { UserResponseDto } from '../users/dto/user-response.dto';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Get('me')
  @UseGuards(FirebaseAuthGuard)
  async getCurrentUser(@Req() request: AuthenticatedRequest): Promise<{
    profileExists: boolean;
    profile: UserResponseDto | null;
  }> {
    const result = await this.authService.getAuthBootstrap(request.user.uid);

    return {
      profileExists: result.profileExists,
      profile: result.profile ? UserResponseMapper.toDto(result.profile) : null,
    };
  }
}
