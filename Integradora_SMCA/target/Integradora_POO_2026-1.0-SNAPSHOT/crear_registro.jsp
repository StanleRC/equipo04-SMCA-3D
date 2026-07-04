<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Crear Registro - Bitácora Digital" />
</jsp:include>

<div class="main-wrapper">
    <jsp:include page="layout/sidebar.jsp" />

    <div class="flex-grow-1 d-flex flex-column" style="background-color: #ffffff; min-height: 100vh;">

        <div class="top-blue-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <div class="content-body d-flex align-items-center justify-content-center flex-grow-1" style="padding: 40px 20px;">
            <div class="container text-center">

                <div class="mb-5">
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" style="max-height: 110px;" class="img-fluid">
                </div>

                <div class="card border-0 shadow selection-card mx-auto">
                    <div class="card-body py-5">
                        <h2 class="fw-bold mb-5" style="color: #4a5568; font-size: 28px;">¿A quién deseas registrar?</h2>

                        <div class="d-flex flex-wrap justify-content-center gap-4">
                            <a href="${pageContext.request.contextPath}/registrar_maestro.jsp" class="btn btn-selection">
                                Profesor
                            </a>

                            <a href="#" class="btn btn-selection">
                                Grupo
                            </a>

                            <a href="#" class="btn btn-selection">
                                Alumno
                            </a>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<jsp:include page="layout/footer.jsp" />