import { Injectable } from '@nestjs/common';
import { UsersService } from '../users/users.service';

@Injectable()
export class AuthService {
  constructor(private readonly usersService: UsersService) {}

  async getAuthBootstrap(firebaseUid: string) {
    const user = await this.usersService.findByFirebaseUid(firebaseUid);

    if (!user) {
      return {
        profileExists: false,
        profile: null,
      };
    }

    return {
      profileExists: true,
      profile: user,
    };
  }
}
