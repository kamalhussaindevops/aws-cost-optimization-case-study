# AWS Cost Audit Checklist

The 28-point checklist behind the case study in this repo. Use it to find waste on
any AWS account — grouped by area, ordered roughly quick-win → strategic.

## Compute
- [ ] EC2 instances under ~40% avg CPU over 14 days → right-size
- [ ] Stopped instances still holding EBS volumes or EIPs
- [ ] Auto Scaling min/desired set higher than needed
- [ ] Spot adoption for non-critical, batch, or fault-tolerant workloads
- [ ] Dev/staging running 24x7 → schedule off-hours shutdown
- [ ] Lambda memory configured well above actual usage

## Storage
- [ ] Unattached EBS volumes
- [ ] gp2 volumes → migrate to gp3 (~20% cheaper, better baseline IOPS)
- [ ] Stale snapshots with no retention policy
- [ ] S3 buckets with no lifecycle policy (Standard → IA → Glacier)
- [ ] S3 Intelligent-Tiering for unpredictable access patterns
- [ ] Cold S3 data eligible for archive tiers

## Networking
- [ ] NAT carrying S3/DynamoDB traffic → replace with free gateway endpoints
- [ ] Idle / unassociated Elastic IPs (billed even when unused)
- [ ] Redundant NAT gateways across AZs → review for consolidation
- [ ] Cross-AZ and inter-region data-transfer charges
- [ ] Unused or idle load balancers

## Databases
- [ ] RDS instance class oversized for actual load → right-size
- [ ] Multi-AZ on non-critical / dev databases → Single-AZ
- [ ] RDS storage gp2 → gp3
- [ ] Backup retention and snapshot sprawl
- [ ] Reserved Instances / Savings Plans for steady-state databases

## Governance & commitments
- [ ] Tagging strategy enforced (Owner, CostCenter, Project, Environment)
- [ ] AWS Config required-tags rule for ongoing enforcement
- [ ] CloudWatch Logs retention set (never "never expire")
- [ ] Cost Explorer, Compute Optimizer, Trusted Advisor all enabled
- [ ] AWS Budgets with alert thresholds
- [ ] Savings Plans / RI coverage analyzed for baseline compute
- [ ] CUR → Athena set up for deep, taggable usage analysis

---

This is the exact checklist behind the before/after audit in this repository.
**Want it run on your AWS account?** — Kamal Hussain, Cloud/DevOps Engineer.
