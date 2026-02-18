export class CreateChallengeDto {
    template_id: string;
    duration_days: number; // 7, 14, 30
    frequency_per_week: number;
    proof_window_start: string;
    proof_window_end: string;
    proof_type: string;
    failure_rule: string;     // 'BURN' | 'CREDIT' | 'DONATE'
    donate_target?: string;   // failure_rule === 'DONATE' 일 때 기관 코드
    amount: number;           // 보증금 금액
}
