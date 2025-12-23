import {useState} from "react"
import { v4 as uuidv4 } from 'uuid';
export default function ToDo(){
    let [addItem,setAddItem]=useState([{task:"",id:uuidv4()}]);
        let [addNewItem,setAddNewItem]=useState("");

function addToList(){
            setAddItem(prev=>[...prev,{ task: addNewItem, id: uuidv4() }]);
            
             setAddNewItem("");
}

        
         function addNewTask(event){
              setAddNewItem(event.target.value);
         }
         let delItem=(id)=>{
             setAddItem(prev=>prev.filter(todo=>todo.id!==id));
         }
     return(
        <>
            <h1>ToDo List</h1>
            <input type="text" value={addNewItem} onChange={addNewTask}/><h1></h1>
            <button onClick={addToList}>Add</button>
            <hr />
            <p>Tasks List</p>
            
            <ul>
                   {addItem.map((todo)=>{
            return <li key={todo.id}>{todo.task}
             <button onClick={() => delItem(todo.id)}>Delete</button>
            </li>
           
                   })
                   }
            </ul>
        </>
     )
}