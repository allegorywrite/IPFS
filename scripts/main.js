const destination = 'DESTINATION_ADDRESS';

async function main() {
  const factory = await ethers.getContractFactory("LimitedNFT");
  const contract = await factory.deploy();
  console.log("NFT Deployed to:", contract.address);
  await contract.mintAndTransfer(destination, 1);
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
