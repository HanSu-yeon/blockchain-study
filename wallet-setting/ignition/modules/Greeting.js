import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("GreetingModule", (m) => {
  const initialGreeting = m.getParameter("initialGreeting", "Hello, Hardhat!");

  const greetingContract = m.contract("Greeting", [initialGreeting]);

  return { greetingContract };
});
