import { useEffect, useState } from 'react';
import Papa from 'papaparse';
import './Home.css';


function Home() {
  const [matrixData, setMatrixData] = useState([]);
  const [variableNames, setVariableNames] = useState([]);
  const [topCorrelatedVariables, setTopCorrelatedVariables] = useState([]);
  const [targetVariable, setTargetVariable] = useState("age_pyramid_total_nyc");
  const [sortType, setSortType] = useState("absolute"); // State for sort type
  const [numberOfVariables, setNumberOfVariables] = useState(5); // New state for the number of variables to display

  // FETCHING :: Function to fetch and parse CSV
  useEffect(() => {
    fetch('../public/correlation_matrix.csv')
      .then(response => response.text())
      .then(csvString => {
        Papa.parse(csvString, {
          header: true,
          dynamicTyping: true,
          skipEmptyLines: true,
          transformHeader: header => header.trim() || "variable_name",
          complete: (results) => {
            if (results.errors.length) {
              console.error("Errors while parsing CSV:", results.errors);
            } else {
              const names = results.data.map(row => row["variable_name"]);
              setVariableNames(names); // Store all variable names for the dropdown
              setMatrixData(results.data);
            }
          },
        });
      });
  }, []);

  // SORTING CORRELATIONS
  useEffect(() => {
    if (matrixData.length > 0 && targetVariable) {
      const hashmapIndex = matrixData.findIndex(hash => hash.variable_name === targetVariable);
      if (hashmapIndex !== -1) {
        const hashmap = matrixData[hashmapIndex];
        let pairs = Object.entries(hashmap);

        // Exclude "variable_name" and correlations of 1 or -1 (self-correlation)
        pairs = pairs.filter(([key, value]) => key !== "variable_name" && value !== 1 && value !== -1);

        // Sort based on the selected sort type
        if (sortType === "absolute") {
          pairs.sort((a, b) => Math.abs(b[1]) - Math.abs(a[1]));
        } else if (sortType === "strong") {
          pairs.sort((a, b) => b[1] - a[1]);
        } else if (sortType === "weak") {
          pairs.sort((a, b) => a[1] - b[1]);
        }

        // Get the top 'numberOfVariables' highest correlations
        const topVariables = pairs.slice(0, numberOfVariables);

        setTopCorrelatedVariables(topVariables);
      }
    }
  }, [matrixData, targetVariable, sortType, numberOfVariables]); // Depend on numberOfVariables as well

  // Update target variable when selection changes
  const handleSelectChange = (event) => {
    setTargetVariable(event.target.value);
  };

  // Handler for changing the sort type
  const handleSortTypeChange = (event) => {
    setSortType(event.target.value);
  };

  // Handler for changing the number of variables
  const handleNumberChange = (event) => {
    setNumberOfVariables(event.target.value);
  };

  return (
    <>
      <div className='body'>
        <h1>Top Correlated Variables for <span className='indicator-container'>{targetVariable}</span></h1>
        
        <div className="controls-container">
          <div className="control-group">
            <h3>Sort By:</h3>
            <select value={sortType} onChange={handleSortTypeChange}>
              <option value="absolute">Absolute Value</option>
              <option value="strong">Strongest Correlation</option>
              <option value="weak">Weakest Correlation</option>
            </select>
          </div>

          <div className="control-group">
            <h3>Number of Results:</h3>
            <input
              type="number"
              value={numberOfVariables}
              onChange={handleNumberChange}
              min="1"
            />
          </div>

          <div className="control-group">
            <h3>Select an Indicator:</h3>
            <select value={targetVariable} onChange={handleSelectChange}>
              {variableNames.map((name, index) => (
                <option key={index} value={name}>{name}</option>
              ))}
            </select>
          </div>
        </div>

        <ul>
          {topCorrelatedVariables.map(([variable, correlation], index) => (
            <li key={index}><span className='indicator-container'>{variable}:</span>  {correlation.toFixed(2)}% correlation</li>
          ))}
        </ul>
      </div>
    </>
  );
}

export default Home;
