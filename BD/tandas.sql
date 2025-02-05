import mysql.connector

# Configuración de la conexión a la base de datos
mydb = mysql.connector.connect(
    host="localhost",
    user="tu_usuario",  # Reemplaza con tu usuario de MySQL
    password="tu_contraseña",  # Reemplaza con tu contraseña de MySQL
    database="tandas"
)

mycursor = mydb.cursor()

# Agregar columnas (si no existen)
try:
    mycursor.execute("""
        ALTER TABLE Tandas 
        ADD COLUMN fecha_inicio DATE,
        ADD COLUMN fecha_fin DATE;
    """)
    mydb.commit()
    print("Columnas 'fecha_inicio' y 'fecha_fin' agregadas a la tabla Tandas.")
except mysql.connector.errors.ProgrammingError as err:
    if err.errno == 1060:  # 1060 es el código de error para "columna duplicada"
        print("Las columnas 'fecha_inicio' y 'fecha_fin' ya existen en la tabla Tandas.")
    else:
        raise err  # Relanzar otros errores

# Modificar la tabla Participantes para que el campo 'clave' tenga un valor predeterminado o permita valores nulos
try:
    mycursor.execute("""
        ALTER TABLE Participantes MODIFY COLUMN clave VARCHAR(255) DEFAULT NULL;
    """)
    mydb.commit()
    print("Campo 'clave' modificado en la tabla Participantes.")
except mysql.connector.errors.ProgrammingError as err:
    if err.errno == 1060:  # 1060 es el código de error para "columna duplicada"
        print("El campo 'clave' ya existe en la tabla Participantes.")
    else:
        raise err  # Relanzar otros errores

def crear_participante():
    while True:
        try:
            nombre = input("Nombre del participante: ")
            telefono = input("Teléfono del participante: ")
            email = input("Email del participante: ")
            break
        except ValueError:
            print("Error: Datos inválidos. Intente de nuevo.")

    sql = "INSERT INTO Participantes (nombre, telefono, email) VALUES (%s, %s, %s)"
    val = (nombre, telefono, email)
    mycursor.execute(sql, val)
    mydb.commit()
    print("Participante creado exitosamente.")


def crear_tanda():
    while True:
        try:
            nombre_tanda = input("Nombre de la tanda: ")
            monto_por_persona = float(input("Monto por persona: "))
            frecuencia_pago = input("Frecuencia de pago (Semanal, Quincenal, Mensual): ")
            num_participantes = int(input("Número de participantes: "))
            fecha_inicio = input("Fecha de inicio (YYYY-MM-DD): ")  # Añadido
            fecha_fin = input("Fecha de fin (YYYY-MM-DD): ")  # Añadido
            break
        except ValueError:
            print("Error: Datos inválidos. Intente de nuevo.")

    sql = "INSERT INTO Tandas (nombre_tanda, monto_por_persona, frecuencia_pago, num_participantes, fecha_inicio, fecha_fin) VALUES (%s, %s, %s, %s, %s, %s)"  # Añadido fecha_inicio y fecha_fin
    val = (nombre_tanda, monto_por_persona, frecuencia_pago, num_participantes, fecha_inicio, fecha_fin)
    mycursor.execute(sql, val)
    mydb.commit()
    print("Tanda creada exitosamente.")


def asignar_participante_a_tanda():
    while True:
        try:
            id_tanda = int(input("ID de la tanda: "))
            id_participante = int(input("ID del participante: "))
            num_tanda = int(input("Número de tanda para este participante: "))
            break
        except ValueError:
            print("Error: Datos inválidos. Intente de nuevo.")

    sql = "INSERT INTO Tandas_Participantes (id_tanda, id_participante, num_tanda) VALUES (%s, %s, %s)"
    val = (id_tanda, id_participante, num_tanda)
    mycursor.execute(sql, val)
    mydb.commit()
    print("Participante asignado a la tanda exitosamente.")


def registrar_pago():
    while True:
        try:
            id_tanda_participante = int(input("ID de la relación Tanda-Participante: "))
            fecha_pago = input("Fecha de pago (YYYY-MM-DD): ")
            monto_pagado = float(input("Monto pagado: "))
            break
        except ValueError:
            print("Error: Datos inválidos. Intente de nuevo.")
    sql = "INSERT INTO Historial_Pagos (id_tanda_participante, fecha_pago, monto_pagado) VALUES (%s, %s, %s)"
    val = (id_tanda_participante, fecha_pago, monto_pagado)
    mycursor.execute(sql, val)
    mydb.commit()
    print("Pago registrado exitosamente.")


# Menú principal
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
        break
    else:
        print("Opción inválida. Intente de nuevo.")

mydb.close()
