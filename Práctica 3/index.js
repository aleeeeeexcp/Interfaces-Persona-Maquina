// VENTANAS MODALES
const addTaskModal = document.querySelector("#add-task-modal");
const descriptionTaskModal = document.querySelector("#description-task-modal");
const toggleMenuModal = document.querySelector("#toggle-menu-modal");

// Ventana modal de añadir tarea
document.querySelector("#open-modal").addEventListener("click", () => {
    addTaskModal.classList.replace("modal-closed", "modal-open");
});

document.querySelector("#close-modal").addEventListener("click", () => {
    addTaskModal.classList.replace("modal-open", "modal-closed");
});

// Ventana modal de descripción de tarea
document.querySelector("#open-modal-d").addEventListener("click", () => {
    descriptionTaskModal.classList.replace("modal-closed-d", "modal-open-d");
});

document.querySelector("#close-modal-d").addEventListener("click", () => {
    descriptionTaskModal.classList.replace("modal-open-d", "modal-closed-d");
});

// Ventana modal de menú
document.querySelector("#open-modal-m").addEventListener("click", () => {
    toggleMenuModal.classList.replace("modal-closed-m", "modal-open-m");
});

document.querySelector("#close-modal-m").addEventListener("click", () => {
    toggleMenuModal.classList.replace("modal-open-m", "modal-closed-m");
});

// OBTENER NUM DE TAREAS ACTIVAS
let taskList = document.getElementById('todo-list');
let contadorElemento = document.getElementById('contador');
function actualizarContador() {
    let togglesActivos = document.querySelectorAll('.toggle:not(:checked)');
    contadorElemento.textContent = togglesActivos.length;
}
actualizarContador();
taskList.addEventListener('change', function (event) {
    if (event.target.classList.contains('toggle')) {
        actualizarContador();
    }
});

// AÑADIR TAREA
document.addEventListener('DOMContentLoaded', function () {
    const taskList = document.getElementById('todo-list');
    function addTask(title, description, dueDate) {
        const li = document.createElement('li');
        li.innerHTML = `
            <input type="checkbox" class="toggle" data-completed="false">
            <span class="task-title">${title}</span>
            <button class="delete-task" aria-label="delete">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash" viewBox="0 0 16 16">
                    <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0z"/>
                    <path d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4zM2.5 3h11V2h-11z"/>
                </svg>
            </button>
            <button class="edit-task" aria-label="edit">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil-square" viewBox="0 0 16 16">
                    <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
                    <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5z"/>
                </svg>
            </button>
        `;

        taskList.appendChild(li);

        alert('¡La tarea se ha guardado correctamente!');
    }

    document.getElementById('close-modal').addEventListener('click', function () {
        const title = document.getElementById('task-title').value;
        const description = document.getElementById('task-description').value;
        const dueDate = document.getElementById('task-due-date').value;

        if (title.trim() === ""){
            alert("Introduce un título");
        } else {
            addTask(title, description, dueDate);
            actualizarContador();
        }
    });
});
