<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Validar incidencias - UTEZ" />
</jsp:include>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cssbitacora_insidencias_Aulas.css?v=12">

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

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

    /* ---------- Modal de confirmación ---------- */

    .capa-modal {
        position: fixed;
        inset: 0;
        background: rgba(20, 28, 45, .55);
        display: none;
        align-items: center;
        justify-content: center;
        z-index: 2000;
        padding: 20px;
    }

    .capa-modal.visible { display: flex; }

    .caja-modal {
        background: #fff;
        border-radius: 14px;
        width: 100%;
        max-width: 470px;
        overflow: hidden;
        box-shadow: 0 14px 40px rgba(0, 0, 0, .25);
    }

    .modal-cabecera {
        background: #1c3862;
        color: #fff;
        padding: 16px 20px;
    }

    .modal-cabecera h3 { margin: 0; font-size: 17px; font-weight: 700; }

    .modal-cabecera p { margin: 4px 0 0; font-size: 12.5px; opacity: .85; }

    .modal-cuerpo { padding: 20px; }

    .resumen-incidencia {
        background: #f7f8fa;
        border-left: 3px solid #1c3862;
        border-radius: 6px;
        padding: 12px 14px;
        font-size: 13px;
        line-height: 1.5;
        margin-bottom: 18px;
    }

    .resumen-incidencia strong { color: #1c3862; }

    .zona-foto {
        border: 2px dashed #cfd6e2;
        border-radius: 10px;
        padding: 18px;
        text-align: center;
        cursor: pointer;
        transition: border-color .2s, background .2s;
    }

    .zona-foto:hover { border-color: #1c3862; background: #f7f8fa; }

    .zona-foto .bi { font-size: 30px; color: #8a97ad; }

    .zona-foto p { margin: 8px 0 0; font-size: 13px; color: #5a6b85; }

    .zona-foto small { display: block; font-size: 11.5px; color: #9aa3ad; margin-top: 3px; }

    #vistaPreviaEvidencia {
        display: none;
        max-width: 100%;
        max-height: 190px;
        border-radius: 8px;
        margin-top: 12px;
    }

    .modal-pie {
        display: flex;
        gap: 10px;
        justify-content: flex-end;
        padding: 0 20px 20px;
    }

    .btn-modal {
        border: none;
        border-radius: 8px;
        padding: 10px 20px;
        font-size: 14px;
        font-weight: 700;
        cursor: pointer;
    }

    .btn-modal-cancelar { background: #e8ecf2; color: #4a5568; }
    .btn-modal-confirmar { background: #0d8a72; color: #fff; }
    .btn-modal-confirmar.descartar { background: #9aa3ad; }
    .btn-modal-confirmar:disabled { opacity: .6; cursor: progress; }
</style>

<div class="main-wrapper">

    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <main class="main-content">

        <div class="top-welcome-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <div class="salones-body">

            <div class="mb-2">
                <a href="javascript:history.back()" class="btn-back">
                    &larr; <u>Elegir otro laboratorio</u>
                </a>
            </div>

            <div class="text-center mb-3">
                <img src="${pageContext.request.contextPath}/assets/img/logoutez.png"
                     alt="Logo UTEZ" style="max-height: 130px;">
            </div>

            <div class="encabezado-tabla">
                <h2 class="titulo-lab">Ingresaste a <c:out value="${labActual}" /></h2>
                <span class="contador-filas">
                    ${listaIncidencias.size()} incidencia<c:if test="${listaIncidencias.size() ne 1}">s</c:if>
                </span>
            </div>

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
                        <th style="width: 15%;">Validar</th>
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

<%--
    Un solo formulario para toda la tabla. Antes había uno por fila y ninguno
    aceptaba archivos; este va en multipart para poder adjuntar la evidencia.
--%>
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

                <label class="zona-foto" for="fotoEvidencia" id="zonaFoto">
                    <i class="bi bi-camera"></i>
                    <p id="textoZonaFoto">Adjuntar fotografía (opcional)</p>
                    <small>PNG o JPG, máximo 5 MB</small>
                </label>

                <input type="file" id="fotoEvidencia" name="fotoEvidencia"
                       accept="image/png, image/jpeg" hidden>

                <img id="vistaPreviaEvidencia" alt="Vista previa de la evidencia">
            </div>

            <div class="modal-pie">
                <button type="button" class="btn-modal btn-modal-cancelar" id="btnCancelarModal">
                    Cancelar
                </button>
                <button type="submit" class="btn-modal btn-modal-confirmar" id="btnConfirmarModal">
                    Confirmar y enviar
                </button>
            </div>

        </form>
    </div>
</div>

<%-- Resultado que devuelve ValidarIncidenciasServlet en ?msj= --%>
<span id="flashMsj" hidden><c:out value="${param.msj}" /></span>

<script>
    (function () {
        var capa = document.getElementById('capaModal');
        var form = document.getElementById('formRevision');
        var campoId = document.getElementById('campoIdReporte');
        var campoAccion = document.getElementById('campoAccion');
        var titulo = document.getElementById('tituloModal');
        var btnConfirmar = document.getElementById('btnConfirmarModal');
        var inputFoto = document.getElementById('fotoEvidencia');
        var preview = document.getElementById('vistaPreviaEvidencia');
        var textoZona = document.getElementById('textoZonaFoto');

        function abrirModal(boton) {
            var esValidar = boton.dataset.accion === 'validar';

            campoId.value = boton.dataset.id;
            campoAccion.value = boton.dataset.accion;

            titulo.textContent = esValidar ? 'Validar incidencia' : 'Descartar incidencia';
            btnConfirmar.classList.toggle('descartar', !esValidar);

            document.getElementById('resumenPc').textContent = boton.dataset.pc || 'No especificada';
            document.getElementById('resumenAlumno').textContent = boton.dataset.alumno || '';
            document.getElementById('resumenDescripcion').textContent = boton.dataset.descripcion || '';

            capa.classList.add('visible');
        }

        function cerrarModal() {
            capa.classList.remove('visible');
            inputFoto.value = '';
            preview.style.display = 'none';
            textoZona.textContent = 'Adjuntar fotografía (opcional)';
            btnConfirmar.disabled = false;
            btnConfirmar.textContent = 'Confirmar y enviar';
        }

        document.querySelectorAll('.btn-abrir-modal').forEach(function (boton) {
            boton.addEventListener('click', function () { abrirModal(boton); });
        });

        document.getElementById('btnCancelarModal').addEventListener('click', cerrarModal);

        // Clic fuera de la caja o tecla Escape también cierran.
        capa.addEventListener('click', function (e) {
            if (e.target === capa) cerrarModal();
        });

        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && capa.classList.contains('visible')) cerrarModal();
        });

        // Validar la imagen aquí evita subir 8 MB para que el servlet la descarte.
        inputFoto.addEventListener('change', function () {
            var archivo = inputFoto.files[0];
            if (!archivo) return;

            if (['image/png', 'image/jpeg'].indexOf(archivo.type) === -1) {
                inputFoto.value = '';
                textoZona.textContent = 'Ese archivo no es PNG ni JPG';
                preview.style.display = 'none';
                return;
            }

            if (archivo.size > 5 * 1024 * 1024) {
                inputFoto.value = '';
                textoZona.textContent = 'La imagen pesa más de 5 MB';
                preview.style.display = 'none';
                return;
            }

            var lector = new FileReader();
            lector.onload = function () {
                preview.src = lector.result;
                preview.style.display = 'block';
            };
            lector.readAsDataURL(archivo);

            textoZona.textContent = archivo.name;
        });

        form.addEventListener('submit', function () {
            // Enviar el correo tarda: sin esto es fácil dar doble clic.
            btnConfirmar.disabled = true;
            btnConfirmar.textContent = 'Enviando...';
        });

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
