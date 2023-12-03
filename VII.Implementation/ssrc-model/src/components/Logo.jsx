/* eslint-disable react/prop-types */
import './Logo.css'; // Import the CSS file for styling

const Logo = ({ link, pathToLogo }) => (
  <div className="logo-container">
    {/* Wrap the image with an anchor tag if a link is provided */}
    <a href={link} target="_blank" rel="noopener noreferrer" style={{ display: 'inline-block' }}>
      <img src={pathToLogo} alt="Logo" className="logo" />
    </a>
  </div>
);

export default Logo;
