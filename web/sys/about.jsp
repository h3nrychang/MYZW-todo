<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title></title>
    <style>
        h2, p {
            color: white;
        }

        body, html {
            margin: 0;
            font-family: Arial, sans-serif;
            overflow-x: hidden;
        }

        .bg-img {
            background-image: url('../static/img/my.png');
            height: 100vh;
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;
            position: fixed;
            width: 100%;
            z-index: -1;
        }

        .content {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            text-align: center;
            position: relative;
            z-index: 1;
        }

        .avatar {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            background-image: url('../static/img/avatar.jpg');
            background-size: cover;
            background-position: center;
        }

        .name {
            margin-top: 20px;
            font-size: 2em;
            color: #fff;
        }

        .signature {
            margin-top: 10px;
            font-size: 1.2em;
            color: #fff;
        }

        .section {
            padding: 20px;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            text-align: center;
            position: relative;
            z-index: 1;
        }

        .section:nth-child(odd) {
            background-color: rgba(40, 60, 80, 0.8);
        }

        .section:nth-child(even) {
            background-color: rgba(40, 60, 80, 0.8);
        }

        .blurred-background {
            backdrop-filter: blur(10px);
            padding: 20px;
            border-radius: 8px;
        }
    </style>
</head>
<body>

<div class="bg-img"></div>

<div class="content">
    <div class="avatar"></div>
    <div class="name">综维中心 待办管理系统 V1.0</div>
    <div class="signature">Henry Chang 张赫原</div>
</div>

<div class="section blurred-background">
    <%--    <div class="blurred-background">--%>
    <h2>待办管理系统 V1.0</h2>
    <p></p>
    <%--    <hr>--%>
    <p>
        实现民族复兴，增强志气、骨气、底气，不负时代，不负韶华.....每一份平凡的努力，终将汇聚成奔涌前行的大江大河；每个人在本职岗位上锐意进取、苦干实干，终将凝聚起国家繁荣进步的澎湃力量。美好的梦想，终究要靠奋斗来取得；生命的辉煌，也只有通过奋斗才能铸就。
    </p><br>
    <p>行路难！行路难！多歧路，今安在？长风破浪会有时，直挂云帆济沧海。——李白</p>

    <%--    </div>--%>
</div>

</body>
</html>