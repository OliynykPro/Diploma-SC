import { task } from "hardhat/config";

task("deploy-factory", "Deploy factory contract").setAction(
    async (_, {ethers}) => {
        try {
            
        } catch (error) {
            console.error(error);
            process.exit(1);
        }
    }
)