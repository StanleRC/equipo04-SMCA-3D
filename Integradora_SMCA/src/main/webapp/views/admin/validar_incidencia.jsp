<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Validar incidencias - UTEZ" />
</jsp:include>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cssbitacora_insidencias_Aulas.css?v=12">

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<%--
    Quién está viendo la pantalla.

    Validar es tarea del docente: el administrador solo observa y recibe el
    aviso por correo. Esto decide qué se DIBUJA; quien impide de verdad que un
    admin valide es la comprobación del servlet, porque el formulario se puede
    enviar a mano aunque el botón no aparezca.
--%>
<c:set var="perfil" value="${not empty sessionScope.usuarioLogueado ? sessionScope.usuarioLogueado : (not empty sessionScope.docente ? sessionScope.docente : sessionScope.usuario)}" />
<c:set var="esAdmin" value="${sessionScope.esAdmin or perfil.rolIdRol eq 1}" />

<style>
    .tabla-wrapper { width: 100%; overflow-x: auto; border: 1px solid #1c3862; }

    .tabla-datos {
        width: 100%;
        border-collapse: collapse;
        table-layout: fixed;
        min-width: 950px;
    }

    .tabla-datos th {
        height: 52px;
        padding: 8px;
        background-color: #1c3862;
        color: #fff;
        border: 1px solid #31517d;
        font-size: 14px;
        font-weight: 700;
        text-align: center;
    }

    .tabla-datos td {
        height: 44px;
        padding: 8px;
        border: 1px solid #c8c8c8;
        font-size: 14px;
        text-align: center;
        vertical-align: middle;
    }

    .tabla-datos td.al-inicio { text-align: left; padding-left: 12px; }

    .tabla-datos tbody tr:hover { background-color: #f4f6fa; }

    .acciones-fila { display: flex; gap: 6px; justify-content: center; }

    .btn-validar, .btn-descartar {
        border: none;
        border-radius: 6px;
        padding: 6px 14px;
        font-size: 12px;
        font-weight: 700;
        color: #fff;
        cursor: pointer;
    }

    .btn-validar { background-color: #0d8a72; }
    .btn-validar:hover { background-color: #0a7560; }

    .btn-descartar { background-color: #9aa3ad; }
    .btn-descartar:hover { background-color: #7d858f; }

    .badge-estado {
        display: inline-block;
        padding: 4px 12px;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 700;
        white-space: nowrap;
    }

    .badge-validado   { background: #dcf3e6; color: #1e7e4a; }
    .badge-descartado { background: #f1f1f1; color: #6b6b6b; }
    .badge-espera     { background: #fdf0d5; color: #8a6100; }

    /* Aviso para el administrador cuando la incidencia sigue pendiente */
    .aviso-espera {
        display: block;
        font-size: 11px;
        color: #8a8a8a;
        line-height: 1.35;
        margin-top: 5px;
    }

    .nota-rol {
        background: #eef3fb;
        border-left: 4px solid #1c3862;
        border-radius: 8px;
        padding: 12px 16px;
        font-size: 13px;
        color: #3f4a5a;
        line-height: 1.5;
        margin-bottom: 14px;
    }

    .encabezado-tabla {
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 12px;
        margin-bottom: 12px;
    }

    .titulo-lab { font-size: 20px; font-weight: 700; color: #1c3862; margin: 0; }

    .contador-filas { font-size: 13px; color: #666; }

    .sin-datos { padding: 34px 12px !important; color: #777; }

    /* ================= Modal de confirmación ================= */

    .capa-modal {
        position: fixed;
        inset: 0;
        background: rgba(15, 23, 42, .6);
        display: none;
        align-items: center;
        justify-content: center;
        z-index: 2000;
        padding: 20px;
    }

    .capa-modal.visible { display: flex; }

    .caja-modal {
        background: #ffffff;
        border-radius: 18px;
        width: 100%;
        max-width: 480px;
        overflow: hidden;
        box-shadow: 0 18px 50px rgba(0, 0, 0, .3);
    }

    /*
        El !important es necesario: cssbitacora_insidencias_Aulas.css define
        reglas para h3 y p que le ganaban en especificidad, y por eso el título
        salía gris deslavado en vez de blanco sobre azul.
    */
    .modal-cabecera {
        background: #1c3862 !important;
        padding: 18px 24px;
    }

    .modal-cabecera h3 {
        margin: 0 !important;
        font-size: 19px !important;
        font-weight: 700 !important;
        color: #ffffff !important;
        text-align: left !important;
    }

    .modal-cabecera p {
        margin: 5px 0 0 !important;
        font-size: 13px !important;
        color: #c7d3e8 !important;
        text-align: left !important;
    }

    .modal-cuerpo { padding: 22px 24px 6px; }

    .resumen-incidencia {
        background: #f5f7fa;
        border-left: 4px solid #1c3862;
        border-radius: 8px;
        padding: 14px 16px;
        font-size: 13.5px;
        line-height: 1.65;
        color: #3f4a5a;
        margin-bottom: 18px;
    }

    .resumen-incidencia strong { color: #1c3862; }

    .etiqueta-campo {
        display: block;
        font-size: 13px;
        font-weight: 600;
        color: #3f4a5a;
        margin-bottom: 7px;
    }

    .campo-comentario {
        width: 100%;
        min-height: 108px;
        padding: 13px 15px;
        border: 1px solid #d7dce5;
        border-radius: 12px;
        font-family: inherit;
        font-size: 14px;
        line-height: 1.5;
        color: #333;
        resize: vertical;
        outline: none;
        box-sizing: border-box;
    }

    .campo-comentario::placeholder { color: #a3acbb; }

    .campo-comentario:focus {
        border-color: #1c3862;
        box-shadow: 0 0 0 3px rgba(28, 56, 98, .1);
    }

    .contador-caracteres {
        display: block;
        text-align: right;
        font-size: 11.5px;
        color: #9aa3ad;
        margin-top: 5px;
    }

    .zona-foto {
        display: block;
        border: 1.5px solid #e2e6ee;
        border-radius: 12px;
        padding: 24px 18px;
        margin-top: 16px;
        text-align: center;
        cursor: pointer;
        background: #ffffff;
        transition: border-color .2s, background .2s;
    }

    .zona-foto:hover { border-color: #1c3862; background: #f7f9fc; }

    .zona-foto .icono-subir { font-size: 26px; color: #6b7688; line-height: 1; }

    .zona-foto .titulo-subir {
        margin: 10px 0 0;
        font-size: 15px;
        font-weight: 600;
        color: #5a6675;
    }

    .zona-foto small {
        display: block;
        font-size: 12px;
        color: #a3acbb;
        margin-top: 2px;
    }

    .zona-foto.con-archivo { border-color: #0d8a72; background: #f2fbf8; }
    .zona-foto.con-error   { border-color: #c0392b; background: #fdf3f2; }

    #vistaPreviaEvidencia {
        display: none;
        max-width: 100%;
        max-height: 180px;
        border-radius: 10px;
        margin: 14px auto 0;
    }

    .modal-pie {
        display: flex;
        gap: 14px;
        justify-content: center;
        padding: 22px 24px 24px;
    }

    .btn-modal {
        border: none;
        border-radius: 10px;
        padding: 12px 34px;
        font-size: 14.5px;
        font-weight: 600;
        cursor: pointer;
        transition: background .2s;
    }

    .btn-modal-confirmar { background: #0d8a72; color: #fff; }
    .btn-modal-confirmar:hover { background: #0a7560; }

    .btn-modal-confirmar.descartar { background: #9aa3ad; }
    .btn-modal-confirmar.descartar:hover { background: #7d858f; }

    .btn-modal-cancelar { background: #1c3862; color: #fff; }
    .btn-modal-cancelar:hover { background: #12243e; }

    .btn-modal:disabled { opacity: .6; cursor: progress; }
</style>

<div class="main-wrapper">

    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <main class="main-content">

        <div class="top-welcome-bar">
            ¡Bienvenido(a)!, Ingresaste como
            <c:choose>
                <c:when test="${esAdmin}">administrador</c:when>
                <c:otherwise>docente</c:otherwise>
            </c:choose>
        </div>

        <div class="salones-body">

            <div class="mb-2">
                <a href="${pageContext.request.contextPath}/IncidenciasServlet" class="btn-back">
                    &larr; <u>Elegir otro laboratorio</u>
                </a>
            </div>

            <div class="text-center mb-3">
                <img src="${pageContext.request.contextPath}/assets/img/logoutez.png"
                     alt="Logo UTEZ" style="max-height: 200px;">
            </div>

            <div class="encabezado-tabla">
                <h2 class="titulo-lab">Ingresaste a <c:out value="${labActual}" /></h2>
                <span class="contador-filas">
                    ${listaIncidencias.size()} incidencia<c:if test="${listaIncidencias.size() ne 1}">s</c:if>
                </span>
            </div>

            <c:if test="${esAdmin}">
                <div class="nota-rol">
                    La revisión de incidencias corresponde al personal docente.
                    Aquí puedes consultar el estado de cada reporte; cuando un docente
                    valide o descarte alguno, recibirás el aviso en tu correo.
                </div>
            </c:if>

            <div class="tabla-wrapper">
                <table class="tabla-datos">
                    <thead>
                    <tr>
                        <th style="width: 8%;">Grado</th>
                        <th style="width: 8%;">Grupo</th>
                        <th style="width: 6%;">PC</th>
                        <th style="width: 14%;">Matrícula</th>
                        <th style="width: 20%;">Nombre</th>
                        <th style="width: 11%;">Fecha</th>
                        <th style="width: 18%;">Incidencia</th>
                        <th style="width: 20%;">
                            <c:choose>
                                <c:when test="${esAdmin}">Estado</c:when>
                                <c:otherwise>Validar</c:otherwise>
                            </c:choose>
                        </th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:choose>
                        <c:when test="${not empty listaIncidencias}">
                            <c:forEach var="inc" items="${listaIncidencias}">
                                <tr>
                                    <td><strong>${inc.grado}</strong></td>
                                    <td><strong>${inc.grupo}</strong></td>
                                    <td>${inc.numeroPc}</td>
                                    <td>${inc.matricula}</td>
                                    <td class="al-inicio">${inc.nombreCompleto}</td>
                                    <td>${inc.fecha}</td>
                                    <td class="al-inicio">${inc.incidencia}</td>

                                    <td>
                                        <c:choose>
                                            <%-- Un reporte ya revisado no se vuelve a tocar:
                                                 el DAO solo actualiza filas en 'Pendiente'. --%>
                                            <c:when test="${inc.estado eq 'Validado'}">
                                                <span class="badge-estado badge-validado">Validado</span>
                                            </c:when>

                                            <c:when test="${inc.estado eq 'Descartado'}">
                                                <span class="badge-estado badge-descartado">Descartado</span>
                                            </c:when>

                                            <%--
                                                Pendiente. El administrador solo ve el estado;
                                                los botones son exclusivos del docente.
                                            --%>
                                            <c:when test="${esAdmin}">
                                                <span class="badge-estado badge-espera">En validación</span>
                                                <small class="aviso-espera">
                                                    Esté atento a su correo
                                                </small>
                                            </c:when>

                                            <c:otherwise>
                                                <div class="acciones-fila">
                                                    <button type="button" class="btn-validar btn-abrir-modal"
                                                            data-accion="validar"
                                                            data-id="${inc.idReporte}"
                                                            data-pc="${inc.numeroPc}"
                                                            data-alumno="${inc.nombreCompleto}"
                                                            data-descripcion="${inc.incidencia}">
                                                        Validar
                                                    </button>

                                                    <button type="button" class="btn-descartar btn-abrir-modal"
                                                            data-accion="descartar"
                                                            data-id="${inc.idReporte}"
                                                            data-pc="${inc.numeroPc}"
                                                            data-alumno="${inc.nombreCompleto}"
                                                            data-descripcion="${inc.incidencia}">
                                                        Descartar
                                                    </button>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>

                        <c:otherwise>
                            <tr>
                                <td colspan="8" class="sin-datos">
                                    No hay incidencias reportadas en <c:out value="${labActual}" />.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

        </div>

    </main>
</div>

<%-- El modal ni siquiera se genera para el administrador. --%>
<c:if test="${not esAdmin}">
    <div class="capa-modal" id="capaModal">
        <div class="caja-modal">

            <form id="formRevision"
                  method="post"
                  enctype="multipart/form-data"
                  action="${pageContext.request.contextPath}/ValidarIncidenciasServlet">

                <input type="hidden" name="idReporte" id="campoIdReporte" value="">
                <input type="hidden" name="accion" id="campoAccion" value="">
                <input type="hidden" name="lab" value="${labActual}">

                <div class="modal-cabecera">
                    <h3 id="tituloModal">Validar incidencia</h3>
                    <p>Se enviará un aviso por correo al administrador.</p>
                </div>

                <div class="modal-cuerpo">

                    <div class="resumen-incidencia">
                        <strong>PC:</strong> <span id="resumenPc"></span><br>
                        <strong>Alumno:</strong> <span id="resumenAlumno"></span><br>
                        <strong>Falla:</strong> <span id="resumenDescripcion"></span>
                    </div>

                    <label class="etiqueta-campo" for="comentario">
                        Comentario de la revisión
                    </label>

                    <textarea id="comentario"
                              name="comentario"
                              class="campo-comentario"
                              maxlength="400"
                              placeholder="Ingresa una breve descripción..."></textarea>

                    <small class="contador-caracteres" id="contadorComentario">0 / 400</small>

                    <label class="zona-foto" for="fotoEvidencia" id="zonaFoto">
                        <i class="bi bi-upload icono-subir"></i>
                        <p class="titulo-subir" id="textoZonaFoto">Subir evidencia</p>
                        <small id="ayudaZonaFoto">(opcional) PNG o JPG, máximo 5 MB</small>
                    </label>

                    <input type="file" id="fotoEvidencia" name="fotoEvidencia"
                           accept="image/png, image/jpeg" hidden>

                    <img id="vistaPreviaEvidencia" alt="Vista previa de la evidencia">
                </div>

                <div class="modal-pie">
                    <button type="submit" class="btn-modal btn-modal-confirmar" id="btnConfirmarModal">
                        Reportar
                    </button>
                    <button type="button" class="btn-modal btn-modal-cancelar" id="btnCancelarModal">
                        Cancelar
                    </button>
                </div>

            </form>
        </div>
    </div>
</c:if>

<%-- Resultado que devuelve ValidarIncidenciasServlet en ?msj= --%>
<span id="flashMsj" hidden><c:out value="${param.msj}" /></span>

<script>
    (function () {
        var capa = document.getElementById('capaModal');

        // El administrador no tiene modal: solo se atienden los mensajes de abajo.
        if (capa) {
            var form = document.getElementById('formRevision');
            var campoId = document.getElementById('campoIdReporte');
            var campoAccion = document.getElementById('campoAccion');
            var titulo = document.getElementById('tituloModal');
            var btnConfirmar = document.getElementById('btnConfirmarModal');
            var inputFoto = document.getElementById('fotoEvidencia');
            var zonaFoto = document.getElementById('zonaFoto');
            var preview = document.getElementById('vistaPreviaEvidencia');
            var textoZona = document.getElementById('textoZonaFoto');
            var ayudaZona = document.getElementById('ayudaZonaFoto');
            var comentario = document.getElementById('comentario');
            var contador = document.getElementById('contadorComentario');

            var abrirModal = function (boton) {
                var esValidar = boton.dataset.accion === 'validar';

                campoId.value = boton.dataset.id;
                campoAccion.value = boton.dataset.accion;

                titulo.textContent = esValidar ? 'Validar incidencia' : 'Descartar incidencia';

                btnConfirmar.classList.toggle('descartar', !esValidar);
                btnConfirmar.textContent = esValidar ? 'Reportar' : 'Descartar';

                document.getElementById('resumenPc').textContent = boton.dataset.pc || 'No especificada';
                document.getElementById('resumenAlumno').textContent = boton.dataset.alumno || '';
                document.getElementById('resumenDescripcion').textContent = boton.dataset.descripcion || '';

                capa.classList.add('visible');
                setTimeout(function () { comentario.focus(); }, 120);
            };

            var cerrarModal = function () {
                capa.classList.remove('visible');

                inputFoto.value = '';
                comentario.value = '';
                contador.textContent = '0 / 400';
                preview.style.display = 'none';

                zonaFoto.classList.remove('con-archivo', 'con-error');
                textoZona.textContent = 'Subir evidencia';
                ayudaZona.textContent = '(opcional) PNG o JPG, máximo 5 MB';

                btnConfirmar.disabled = false;
            };

            document.querySelectorAll('.btn-abrir-modal').forEach(function (boton) {
                boton.addEventListener('click', function () { abrirModal(boton); });
            });

            document.getElementById('btnCancelarModal').addEventListener('click', cerrarModal);

            capa.addEventListener('click', function (e) {
                if (e.target === capa) cerrarModal();
            });

            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape' && capa.classList.contains('visible')) cerrarModal();
            });

            comentario.addEventListener('input', function () {
                contador.textContent = comentario.value.length + ' / 400';
            });

            // Validar la imagen aquí evita subir 8 MB para que el servlet la descarte.
            inputFoto.addEventListener('change', function () {
                var archivo = inputFoto.files[0];

                zonaFoto.classList.remove('con-archivo', 'con-error');
                if (!archivo) return;

                if (['image/png', 'image/jpeg'].indexOf(archivo.type) === -1) {
                    inputFoto.value = '';
                    zonaFoto.classList.add('con-error');
                    textoZona.textContent = 'Ese archivo no es PNG ni JPG';
                    ayudaZona.textContent = 'Elige otra imagen';
                    preview.style.display = 'none';
                    return;
                }

                if (archivo.size > 5 * 1024 * 1024) {
                    inputFoto.value = '';
                    zonaFoto.classList.add('con-error');
                    textoZona.textContent = 'La imagen pesa más de 5 MB';
                    ayudaZona.textContent = 'Elige una más ligera';
                    preview.style.display = 'none';
                    return;
                }

                var lector = new FileReader();
                lector.onload = function () {
                    preview.src = lector.result;
                    preview.style.display = 'block';
                };
                lector.readAsDataURL(archivo);

                zonaFoto.classList.add('con-archivo');
                textoZona.textContent = archivo.name;
                ayudaZona.textContent = 'Haz clic para cambiarla';
            });

            form.addEventListener('submit', function () {
                // Enviar el correo tarda: sin esto es fácil dar doble clic.
                btnConfirmar.disabled = true;
                btnConfirmar.textContent = 'Enviando...';
            });
        }

        // ---------- Mensajes de resultado ----------
        var msj = document.getElementById('flashMsj').textContent.trim();

        if (msj && typeof Swal !== 'undefined') {
            if (msj === 'ok') {
                Swal.fire({
                    icon: 'success',
                    title: 'Incidencia revisada',
                    text: 'Se envió el aviso por correo al administrador.',
                    timer: 2400,
                    showConfirmButton: false
                });
            } else if (msj === 'ok_sin_correo') {
                Swal.fire({
                    icon: 'warning',
                    title: 'Incidencia revisada',
                    text: 'El cambio se guardó, pero no se pudo enviar el correo.'
                });
            } else if (msj === 'sin_permiso') {
                Swal.fire({
                    icon: 'info',
                    title: 'Solo el docente puede validar',
                    text: 'Como administrador recibirás el aviso por correo cuando se revise.'
                });
            } else if (msj === 'error') {
                Swal.fire({
                    icon: 'error',
                    title: 'No se pudo procesar',
                    text: 'Puede que otra persona ya la haya revisado.'
                });
            }
        }

        // Se limpia la URL para que recargar no repita la alerta.
        if (msj && window.history.replaceState) {
            var limpia = window.location.search
                .replace(/[?&]msj=[^&]*/, '')
                .replace(/^&/, '?');
            window.history.replaceState({}, document.title, window.location.pathname + limpia);
        }
    })();
</script>

<jsp:include page="/views/layout/footer.jsp" />
