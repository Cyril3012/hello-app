resource "aws_security_group_rule" "nodeport_30080" {
  type              = "ingress"
  from_port         = 30080
  to_port           = 30080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks.node_security_group_id
}
