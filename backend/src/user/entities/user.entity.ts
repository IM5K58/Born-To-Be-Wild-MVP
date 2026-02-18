import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity()
export class User {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ nullable: true })
    provider: string; // 'google', 'kakao', etc.

    @Column({ nullable: true })
    provider_uid: string;

    @Column({ unique: true, nullable: true })
    nickname: string;

    @Column({ default: 0 })
    credits: number; // 앱 내 크레딧 (소각 방식 선택 시 적립)

    @Column({ default: false })
    credit_used: boolean; // 크레딧 전환 1회 사용 여부

    @CreateDateColumn()
    created_at: Date;
}
