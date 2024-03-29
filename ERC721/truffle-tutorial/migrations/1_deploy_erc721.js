const myERC721 = artifacts.require("MyERC721");

module.exports = function (deployer) {
  deployer.deploy(myERC721);
};
