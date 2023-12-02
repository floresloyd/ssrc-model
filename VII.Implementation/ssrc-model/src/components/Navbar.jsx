/* eslint-disable no-unused-vars */
import "./Navbar.css";
import { NavLink } from "react-router-dom";
import logo from './d2g_logo.png'; // Import the logo image

function Navbar() {
  return (
    <div className="navbar">
      <img src={logo} alt="Logo" className="logo" /> {/* Use imported logo */}
      <NavLink to="/" exact className="nav-link" activeClassName="nav-link-selected"> Home </NavLink>
      <NavLink to="/recommend" className="nav-link" activeClassName="nav-link-selected"> Recommend </NavLink>
      <NavLink to="/chat" className="nav-link" activeClassName="nav-link-selected"> Chat </NavLink>
    </div>
  );
}

export default Navbar;
