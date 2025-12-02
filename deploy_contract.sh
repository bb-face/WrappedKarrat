source .env

# Deploy to Studio Chain testnet
forge script script/DeployWKARRAT.s.sol \
  --rpc-url $RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast