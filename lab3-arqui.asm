
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

.DATA 
       
       
    cadena0 db 0dh, 0ah,0dh, 0ah,"Menu de opciones:", 0dh, 0ah
            db "1. Conversion de minuscula a mayuscula", 0dh, 0ah
            db "2. Caracter en bucle", 0dh, 0ah  
            db "3. Terminar programa" , 0dh,0ah
    cad3    db 0dh, 0ah, "Seleccione una opcion: $"   
    cad4    db " (No es una opcion valida) $" , 0dh, 0ah     
    
    
    cadena1 db 0dh,0ah,"Ingresar letra minuscula: $"  
    cadena2 db 0dh,0ah,0dh,0ah,"Presione la tecla SPACE para ir a menu" , 0dh,0ah, "$"
    cadena3 db " (No es una letra minuscula) $"
         
    cadenaop1 db 0dh, 0ah,"Ingrese un caracter: $"
    cadenaop2 db 0dh, 0ah,"Numero de impresiones: $"  
    cadenaop3 db "  (no es un numero valido)", 0dh, 0ah, "$"
    cadenaop4 db 0dh, 0ah,"Resultado: $"      
            
    salto db 0dh,0ah,"$" 
        

.CODE  
        
        
    Ajuste_video: 
    
        mov ah,00h
        mov al,03h                  ; Ajusta el modo de video 
        int 10h
        
        
    Mostrar_Menu:                 
        mov dx,offset cadena0
        mov ah,09h
        int 21h                      ; Muestra el menu en pantalla
        
   
     Verificador_menu:                
         mov ah,1
         int 21h         
          
    
    Leer_Op:                    
        cmp al,31h                           ;compara con el ascii de 1 (31h)
        je  Opcion1                          ;si es = salta a opcion1
        
        cmp al,32h                           ;compara con el ascii de 2 (32h)
        je  Opcion2                          ;si es = salta a opcion2 
        
        cmp al,33h
        je  Opcion3
        jmp Mensaje_menu                     ; si ninguna es = salta a mensaje_menu
            
            
    Mensaje_menu:      
        mov dx,offset cad4
        mov ah,09h
        int 21h                              ;muestra la cadena2 en pantalla
        jmp Mostrar_Menu                     ;Salta a mostrar_menu
    
         
    Opcion1:
 
                    
            Mostrar:                 
                mov dx,offset cadena2        ;muestra la cadena2 en pantalla
                mov ah,09h
                int 21h
                mov dx,offset cadena1
                mov ah,09h
                int 21h                      ;muestra la cadena1 en pantalla
                 
            
            Verificador:                 
                mov ah,1
                int 21h
                cmp al,20h                   ;compara con el ascii de SPACE (20h)
                je  Mostrar_menu             ; si es = salta a menu
               
               
            mayora:           
                cmp al,61h                   ;compara con el ascii de a (61h)
                jae menora                   ;si es >= salta a mejora
                jmp Mensaje                  ;si no es <= salta a mensaje
               
               
            menora:                       
                cmp al,07Ah                  ;compara con el ascii de z (61h)
                jbe Resultado                ;si es <= salta a resultado
                jmp Mensaje                  ;si no es <= salta a mensaje
               
            
            Mensaje:                  
                mov dx,offset cadena3       ;muestra cadena3 si no se cumple lo de mayora y menora
                mov ah,09h
                int 21h
                jmp Mostrar                 ;muestra nuevamente "mostrar"
            
                
            Resultado:                                           
                sub al,20h                  ;Le resta a al 20h
                mov bl,3ch
                mov ah,09h  
                mov cx,1
                int 10h
                jmp Mostrar                 ;al finalizar salta a mostrar

             
             
    Opcion2: 

        
            Mostrarop:                                 
                mov dx,offset cadena2
                mov ah,09h                  
                int 21h                      ;muestra la cadena2 en pantalla
                mov dx,offset cadenaop1      
                mov ah,09h
                int 21h                      ;muestra la cadenaop1 en pantalla
               
                
            Verificadorop:                
                mov ah,1
                int 21h
                cmp al,20h                   ;compara que el ascii de SPACE
                je  Mostrar_menu             ;si es = salta a menu

                mov bl,al                    ;mueve el caracter ingresado a bl
              
              
            Mostrar2:
                mov dx,offset cadenaop2
                mov ah,09h
                int 21h                      ;muestra la cadenaop 2 en pantalla
              
              
            Leer_caracter:
                mov ah,1
                int 21h                      ;lee el caracter
             
             
            caracter_menor:
                cmp al,30h                   ;compara que el caracter con 0 
                jae caracter_mayor           ;salta a caracter2 si es >= a 0
                jmp Mensajeop
              
                
            caracter_mayor:
                cmp al,39h                   ;compara que el caracter con 9
                jbe loop1                    ;salta a loop1 si es <= a 9
                jmp Mensajeop
              
              
            Mensajeop:
                mov dx,offset cadenaop3
                mov ah,09h          
                int 21h                      ;muestra la cadenaop 3 en pantalla
                jmp Mostrar2                 ;salta a "Mostrar"
              
              
            loop1:            
                mov cl,al                    
                sub cl,30h                   ;mueve el registro al a cl
                mov [10h],cl                 ;resta 30ah a cl
                mov dx,offset cadenaop4
                mov ah,09h          
                int 21h                      ;imprime cadenaop4
                mov bh,16                    
                 
                       
            Bucle: 
                mov cl,[10h]                 ;la direccion de memoria a cl
                cmp bh,0                     ;compara bh con 0
                jz  Mostrarop                ;si es = 0 salta a Mostrarop
                jmp Imprimir                 ;si no es = 0 salta a imprimir
                                 
                             
            Imprimir:           
                cmp cl,0                     ;compara cl con 0
                jz  salir_imprimir           ;si = 0 salta a salir_imprimir
                mov ah,02h                   
                mov dl,bl       
                int 21h                      ;caracter a imprimir
                dec cl                       ;decrementa cl 
                jmp Imprimir                 ; salta a imprimir
            
                
            salir_imprimir:
                dec bh                       ;decrementa bh
                mov dx, offset salto         
                mov ah,09h
                int 21h                      ;imprimime cadena salto
                jmp Bucle                    ; salta a buble
                  
            
    Opcion3: 
            
        mov ah,4ch
        int 21h                              ;Finaliza ejecucion del programa

ret



