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

    @CreateDateColumn()
    created_at: Date;
}
