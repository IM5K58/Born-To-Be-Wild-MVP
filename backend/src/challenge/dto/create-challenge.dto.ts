export class CreateChallengeDto {
    template_id: string;
    duration_days: number; // 7, 14, 30
    frequency_per_week: number;
    proof_window_start: string;
    proof_window_end: string;
    proof_type: string;
    failure_rule: string;
    amount: number; // Deposit amount
}
