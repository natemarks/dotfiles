
ssmconnect() {
  aws ssm start-session --target "${1}"
}