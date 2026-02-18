import { Controller, Post, Body, Get, Param } from '@nestjs/common';
import { UserService } from './user.service';
import { CreateUserDto } from './dto/create-user.dto';

@Controller('users')
export class UserController {
  constructor(private readonly userService: UserService) { }

  @Post('login')
  async login(@Body() body: { provider: string; provider_id: string; nickname?: string }) {
    let user = await this.userService.findOneByProvider(body.provider, body.provider_id);
    if (!user) {
      // Append provider+timestamp to avoid unique constraint violation on nickname
      const baseNickname = body.nickname || 'User';
      const uniqueNickname = `${baseNickname}-${body.provider}-${Date.now()}`;
      user = await this.userService.create({
        provider: body.provider,
        provider_uid: body.provider_id,
        nickname: uniqueNickname,
      });
    }
    return user;
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.userService.findOne(id);
  }
}
