/* eslint-disable no-unused-vars */
import { NavLink } from "react-router-dom";

function Navbar() {
  return (
    <div>
      <NavLink to="/"> Home </NavLink>
      <NavLink to="/recommend"> Recommend </NavLink>
      <NavLink to="/chat"> Chat </NavLink>
    </div>
  );
}

export default Navbar;
