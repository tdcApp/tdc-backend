import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ClassesService } from './classes.service';
import { FirebaseAuthGuard } from '../auth/guards/firebase-auth.guard';
import { GetClassesQueryDto } from './dto/get-classes-query.dto';

@Controller('classes')
export class ClassesController {
  constructor(private readonly classesService: ClassesService) {}

  @Get()
  @UseGuards(FirebaseAuthGuard)
  getClasses(@Query() query: GetClassesQueryDto) {
    return this.classesService.findAll(query);
  }
}
