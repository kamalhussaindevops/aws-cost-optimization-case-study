# Audit Findings Log

## Engagement framing

A cost-optimization audit on a simulated small-SaaS AWS environment, deliberately seeded with common waste. Methodology, Terraform diff, and Cost Explorer screenshots are real. NOTE: account is an AWS Free Plan account (instance types restricted to free-tier-eligible), so the hero finding is NAT-gateway elimination + governance waste, not compute downsizing.

## Day 0 — 2026-06-11, us-east-1

* Instances: i-090e33e201f0ca5f3, i-05e73cbde9f8399ef (t3.micro, Online via SSM)
* NAT gateway: nat-0f061c357ec316161 (the hero cost finding)
* RDS: costcase-mysql (db.t3.micro, gp2)
* S3: costcase-data-20260611090610871100000002 (no lifecycle policy)
* Cost Explorer enabled: [y]
* Day-0 screenshot saved: [y]
* Baseline environment successfully provisioned and verified.
* Terraform apply completed without manual console modifications.
* Audit log initiated and evidence collection started.

## Findings (fill as data arrives)

* F1 NAT gateway: replace with S3/DynamoDB VPC endpoints. Est saving: Pending Cost Explorer data.
* F2 Idle EIPs (2): release. Est saving: Pending Cost Explorer data.
* F3 Unattached EBS (2x50GB gp2): delete + gp2→gp3. Est saving: Pending Cost Explorer data.
* F4 S3 no lifecycle: add Standard→IA→Glacier transition policy. Est saving: Pending Cost Explorer data.
* F5 CloudWatch logs no retention: set 30-day retention. Est saving: Pending Cost Explorer data.
* F6 No tagging governance: enforce default_tags and AWS Config rule.
* F7 EC2/RDS always-on: schedule off-hours shutdown using Lambda + EventBridge.

## Next Steps

1. Wait approximately 24 hours for Cost Explorer usage data to populate.
2. Record actual costs for NAT Gateway, EIP, EBS, S3, CloudWatch, and related resources.
3. Quantify F1–F7 monthly savings opportunities.
4. Implement optimized Terraform configuration under the optimized/ state.
5. Re-deploy optimized infrastructure.
6. Capture post-optimization evidence and screenshots.
7. Produce before-vs-after savings analysis for the final case study.

## Before/After summary (fill at the end)

| Item               | Before $/mo | After $/mo |  Saving |
| ------------------ | ----------: | ---------: | ------: |
| NAT Gateway        |     Pending |    Pending | Pending |
| Elastic IPs        |     Pending |    Pending | Pending |
| EBS Storage        |     Pending |    Pending | Pending |
| S3 Lifecycle       |     Pending |    Pending | Pending |
| CloudWatch Logs    |     Pending |    Pending | Pending |
| EC2/RDS Scheduling |     Pending |    Pending | Pending |
| **Total**          |     Pending |    Pending | Pending |

## Status

* Baseline: ✅ Complete
* Evidence Collection: ✅ Started
* Cost Data Collection: ⏳ Waiting for Cost Explorer
* Optimization Phase: ⏳ Pending
* Final Case Study: ⏳ Pending

