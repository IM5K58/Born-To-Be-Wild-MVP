import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from './../src/app.module';

describe('App Flow (e2e)', () => {
  let app: INestApplication;
  let userId: string;
  let challengeId: string;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  it('/users/login (POST) - Create User', async () => {
    const res = await request(app.getHttpServer())
      .post('/users/login')
      .send({
        provider: 'google',
        provider_id: `test-user-${Date.now()}`,
        nickname: 'TestUser',
      })
      .expect(201);

    userId = res.body.id;
    expect(userId).toBeDefined();
  });

  it('/challenges (POST) - Create Draft Challenge', async () => {
    const res = await request(app.getHttpServer())
      .post('/challenges')
      .send({
        user_id: userId,
        template_id: 'wakeup',
        amount: 10000,
        frequency_per_week: 7,
      })
      .expect(201);

    challengeId = res.body.id;
    expect(res.body.status).toBe('DRAFT');
  });

  it('/challenges/:id/activate (POST) - Activate Challenge', async () => {
    const res = await request(app.getHttpServer())
      .post(`/challenges/${challengeId}/activate`)
      .send({ amount: 10000 })
      .expect(201);

    expect(res.body.status).toBe('ACTIVE');
    expect(res.body.deposit.status).toBe('LOCKED');
  });

  it('/missions/today (GET) - Get Today Mission', async () => {
    const res = await request(app.getHttpServer())
      .get(`/missions/today?challenge_id=${challengeId}`)
      .expect(200);

    expect(res.body.challenge_id).toBe(challengeId);
    expect(res.body.codeword).toBeDefined();
  });
});
