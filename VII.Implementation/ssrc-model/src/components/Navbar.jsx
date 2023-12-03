/* eslint-disable no-unused-vars */
import "./Navbar.css";
import { NavLink } from "react-router-dom";
import logo from '../assets/d2g_logo.png'; // Import the logo image

function Navbar() {
  return (
    <div className="navbar">
      <img src={logo} alt="Logo" className="logo" /> {/* Use imported logo */}
      <NavLink 
        to="/" 
        className={({ isActive }) => isActive ? "nav-link nav-link-selected" : "nav-link"}
      >
        Home 
      </NavLink>
      <NavLink 
        to="/recommend" 
        className={({ isActive }) => isActive ? "nav-link nav-link-selected" : "nav-link"}
      >
        About 
      </NavLink>
    </div>
  );
}

export default Navbar;
