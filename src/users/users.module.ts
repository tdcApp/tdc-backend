import { Module } from '@nestjs/common';
import { FirebaseModule } from '../auth/firebase.module';
import { UsersController } from './users.controller';
import { UsersService } from './users.service';

@Module({
  imports: [FirebaseModule],
  controllers: [UsersController],
  providers: [UsersService],
  exports: [UsersService],
})
export class UsersModule {}
