import { Module } from '@nestjs/common';
import { ClassesController } from './classes.controller';
import { ClassesService } from './classes.service';
import { UsersModule } from '../users/users.module';
import { FirebaseModule } from '../auth/firebase.module';

@Module({
  imports: [UsersModule, FirebaseModule],
  controllers: [ClassesController],
  providers: [ClassesService],
  exports: [ClassesService],
})
export class ClassesModule {}
