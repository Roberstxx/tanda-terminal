import mysql.connector  # Importamos la librería para conectar con MySQL

# Configuración de la conexión a la base de datos
mydb = mysql.connector.connect(
    host="localhost",
    user="tu_usuario",  # Reemplaza con tu usuario de MySQL
    password="tu_contraseña",  # Reemplaza con tu contraseña de MySQL
    database="tandas"  # Conectamos a la base de datos 'tandas'
)

mycursor = mydb.cursor()  # Creamos un cursor para ejecutar consultas SQL

# Agregar columnas (si no existen) a la tabla 'Tandas'
try:
    mycursor.execute("""
        ALTER TABLE Tandas 
        ADD COLUMN fecha_inicio DATE,
        ADD COLUMN fecha_fin DATE;
    """)
    mydb.commit()  # Confirmamos los cambios en la base de datos
    print("Columnas 'fecha_inicio' y 'fecha_fin' agregadas a la tabla Tandas.")
except mysql.connector.errors.ProgrammingError as err:
    if err.errno == 1060:  # Código de error 1060: "columna duplicada"
        print("Las columnas 'fecha_inicio' y 'fecha_fin' ya existen en la tabla Tandas.")
    else:
        raise err  # Relanzamos otros errores desconocidos

# Modificar la tabla 'Participantes' para que el campo 'clave' permita valores nulos
try:
    mycursor.execute("""
        ALTER TABLE Participantes MODIFY COLUMN clave VARCHAR(255) DEFAULT NULL;
    """)
    mydb.commit()
    print("Campo 'clave' modificado en la tabla Participantes.")
except mysql.connector.errors.ProgrammingError as err:
    if err.errno == 1060:  
        print("El campo 'clave' ya existe en la tabla Participantes.")
    else:
        raise err  

# Función para crear un participante
def crear_participante():
    while True:
        try:
            nombre = input("Nombre del participante: ")
            telefono = input("Teléfono del participante: ")
            email = input("Email del participante: ")
            break  # Si la entrada es válida, salimos del bucle
        except ValueError:
            print("Error: Datos inválidos. Intente de nuevo.")

    # Insertamos el nuevo participante en la tabla 'Participantes'
    sql = "INSERT INTO Participantes (nombre, telefono, email) VALUES (%s, %s, %s)"
    val = (nombre, telefono, email)
    mycursor.execute(sql, val)
    mydb.commit()
    print("Participante creado exitosamente.")

# Función para crear una nueva tanda
def crear_tanda():
    while True:
        try:
            nombre_tanda = input("Nombre de la tanda: ")
            monto_por_persona = float(input("Monto por persona: "))
            frecuencia_pago = input("Frecuencia de pago (Semanal, Quincenal, Mensual): ")
            num_participantes = int(input("Número de participantes: "))
            fecha_inicio = input("Fecha de inicio (YYYY-MM-DD): ")  
            fecha_fin = input("Fecha de fin (YYYY-MM-DD): ")  
            break
        except ValueError:
            print("Error: Datos inválidos. Intente de nuevo.")

    # Insertamos la nueva tanda en la tabla 'Tandas'
    sql = "INSERT INTO Tandas (nombre_tanda, monto_por_persona, frecuencia_pago, num_participantes, fecha_inicio, fecha_fin) VALUES (%s, %s, %s, %s, %s, %s)"
    val = (nombre_tanda, monto_por_persona, frecuencia_pago, num_participantes, fecha_inicio, fecha_fin)
    mycursor.execute(sql, val)
    mydb.commit()
    print("Tanda creada exitosamente.")

# Función para asignar un participante a una tanda
def asignar_participante_a_tanda():
    while True:
        try:
            id_tanda = int(input("ID de la tanda: "))
            id_participante = int(input("ID del participante: "))
            num_tanda = int(input("Número de tanda para este participante: "))
            break
        except ValueError:
            print("Error: Datos inválidos. Intente de nuevo.")

    # Insertamos la relación entre el participante y la tanda en la tabla 'Tandas_Participantes'
    sql = "INSERT INTO Tandas_Participantes (id_tanda, id_participante, num_tanda) VALUES (%s, %s, %s)"
    val = (id_tanda, id_participante, num_tanda)
    mycursor.execute(sql, val)
    mydb.commit()
    print("Participante asignado a la tanda exitosamente.")

# Función para registrar un pago de un participante
def registrar_pago():
    while True:
        try:
            id_tanda_participante = int(input("ID de la relación Tanda-Participante: "))
            fecha_pago = input("Fecha de pago (YYYY-MM-DD): ")
            monto_pagado = float(input("Monto pagado: "))
            break
        except ValueError:
            print("Error: Datos inválidos. Intente de nuevo.")

    # Insertamos el registro de pago en la tabla 'Historial_Pagos'
    sql = "INSERT INTO Historial_Pagos (id_tanda_participante, fecha_pago, monto_pagado) VALUES (%s, %s, %s)"
    val = (id_tanda_participante, fecha_pago, monto_pagado)
    mycursor.execute(sql, val)
    mydb.commit()
    print("Pago registrado exitosamente.")

# Menú principal del sistema
while True:
    print("\nSistema Gestor de Tandas")
    print("1. Crear participante")
    print("2. Crear tanda")
    print("3. Asignar participante a tanda")
    print("4. Registrar pago")
    print("5. Salir")

    opcion = input("Selecciona una opción: ")

    if opcion == "1":
        crear_participante()
    elif opcion == "2":
        crear_tanda()
    elif opcion == "3":
        asignar_participante_a_tanda()
    elif opcion == "4":
        registrar_pago()
    elif opcion == "5":
        break  # Salimos del bucle y terminamos el programa
    else:
        print("Opción inválida. Intente de nuevo.")

# Cerramos la conexión con la base de datos al finalizar el programa
mydb.close()

