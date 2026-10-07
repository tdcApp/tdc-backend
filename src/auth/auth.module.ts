import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { FirebaseAdminService } from './firebase-admin.service';
import { FirebaseAuthGuard } from './guards/firebase-auth.guard';
import { AuthController } from './auth.controller';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [UsersModule],
  controllers: [AuthController],
  providers: [AuthService, FirebaseAdminService, FirebaseAuthGuard],
  exports: [AuthService, FirebaseAdminService, FirebaseAuthGuard],
})
export class AuthModule {}
