import Navbar from "./components/Navbar"
import Home from "./pages/Home"
import { BrowserRouter } from 'react-router-dom';
import Logo from "./components/Logo";
import moaLogo from "./assets/moa-logo.png"
import bttLogo from "./assets/btt-logo.png"
import helmsLogo from "./assets/helmsley-logo.png"
import "./App.css"

const App = () => {
  return(
    <div> {/* Set the background color here */}
      <BrowserRouter>
        <Navbar/>
      </BrowserRouter>      
      <Home/>
      <div className="logo-wrapper"> {/* New wrapper div for logos */}
        <Logo link="https://www.breakthroughtech.org/" pathToLogo={bttLogo} />
        <Logo link="https://measureofamerica.org/" pathToLogo={moaLogo} />
        <Logo link="https://helmsleytrust.org/" pathToLogo={helmsLogo} />
      </div>
    </div>
  )
}

export default App;
