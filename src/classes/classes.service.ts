import { Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DatabaseService } from '../database/database.service';
import { classes } from '../database/schema';
import type { GetClassesQueryDto } from './dto/get-classes-query.dto';

@Injectable()
export class ClassesService {
  constructor(private readonly databaseService: DatabaseService) {}

  findAll(query: GetClassesQueryDto) {
    const conditions = query.type ? eq(classes.type, query.type) : undefined;

    return this.databaseService.db.select().from(classes).where(conditions);
  }
}
