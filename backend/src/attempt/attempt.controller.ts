import { Controller, Post, Body, UploadedFile, UseInterceptors, Get, Param, Query } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { AttemptService } from './attempt.service';

@Controller('attempts')
export class AttemptController {
  constructor(private readonly attemptService: AttemptService) { }

  @Post()
  @UseInterceptors(FileInterceptor('file'))
  create(
    @Body() body: { challenge_id: string; mission_id: string; nonce: string; user_id: string },
    @UploadedFile() file: Express.Multer.File,
  ) {
    // In real app, user_id from auth guard
    return this.attemptService.submitProof(body.user_id, {
      challenge_id: body.challenge_id,
      mission_id: body.mission_id,
      file,
      nonce: body.nonce,
    });
  }

  @Get()
  findAll(@Query('user_id') userId: string) {
    return this.attemptService.findAll(userId);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.attemptService.findOne(id);
  }
}
