 #ifdef VERTEX_SHADER
 precision highp float;
uniform mat4 view = mat4(1);
uniform mat4 proj = mat4(1);
uniform float iTime;

flat out int vM;
out vec2 vCoord;



int drawQuad(mat4 universal_trans, mat4 universal_rot, mat4 draw_offset, mat4 change, mat4 scaling, mat4 translation, mat4 rotation, int offset, int n){

   mat4 vp = proj*view;
   mat4 modelView = translation * rotation * scaling;

  // mat4 sin_rot = sin_rot(iTime, 1);

    vec2 verts[] = vec2[](
    vec2(0,0),
    vec2(1,0),
    vec2(0,1),
    vec2(0,1),
    vec2(1,0),
    vec2(1,1)
  );

  int vID = gl_VertexID - offset;

    if(vID < 0 || vID>=verts.length())return verts.length();


    gl_Position = draw_offset * change * modelView * vec4(verts[vID]*2-1,0.f,1.f);
    gl_Position = vp * universal_rot * universal_trans * gl_Position;

    vM = n;
    vCoord = verts[vID];

    return verts.length();

}

mat4 _translate(float x, float y, float z)
{
    mat4 translation1 = mat4(1.0, 0.0, 0.0, 0.0,
                        0.0, 1.0, 0.0, 0.0,
                        0.0, 0.0, 1.0, 0.0,
                        x, y, z, 1.0);
    return translation1;
}

mat4 _rotateZ(float angle)
{
    mat4 rotation = mat4(cos(angle), -sin(angle), 0.0, 0.0,
                        sin(angle), cos(angle), 0.0, 0.0,
                        0.0, 0.0, 1.0, 0.0,
                        0, 0, 0.0, 1.0);
    // mat4 rotation = mat4(cos(angle), 0.0, sin(angle), 0.0,
    //                      0.0,        1.0, 0.0,        0.0,
    //                     -sin(angle), 0.0, cos(angle), 0.0,
    //                     0, 0, 0.0, 1.0);
    // mat4 rotation = mat4(1.0, 0.0,        0.0,        0.0,
    //                      0.0, cos(angle), -sin(angle),0.0,
    //                      0.0, sin(angle), cos(angle), 0.0,
    //                     0, 0, 0.0, 1.0);
    return rotation;
}

mat4 _rotateY(float angle)
{
    // mat4 rotation = mat4(cos(angle), -sin(angle), 0.0, 0.0,
    //                     sin(angle), cos(angle), 0.0, 0.0,
    //                     0.0, 0.0, 1.0, 0.0,
    //                     0, 0, 0.0, 1.0);
    mat4 rotation = mat4(cos(angle), 0.0, sin(angle), 0.0,
                         0.0,        1.0, 0.0,        0.0,
                        -sin(angle), 0.0, cos(angle), 0.0,
                        0, 0, 0.0, 1.0);
    // mat4 rotation = mat4(1.0, 0.0,        0.0,        0.0,
    //                      0.0, cos(angle), -sin(angle),0.0,
    //                      0.0, sin(angle), cos(angle), 0.0,
    //                     0, 0, 0.0, 1.0);
    return rotation;
}

mat4 _rotateX(float angle)
{
    // mat4 rotation = mat4(cos(angle), -sin(angle), 0.0, 0.0,
    //                     sin(angle), cos(angle), 0.0, 0.0,
    //                     0.0, 0.0, 1.0, 0.0,
    //                     0, 0, 0.0, 1.0);
    // mat4 rotation = mat4(cos(angle), 0.0, sin(angle), 0.0,
    //                      0.0,        1.0, 0.0,        0.0,
    //                     -sin(angle), 0.0, cos(angle), 0.0,
    //                     0, 0, 0.0, 1.0);
    mat4 rotation = mat4(1.0, 0.0,        0.0,        0.0,
                         0.0, cos(angle), -sin(angle),0.0,
                         0.0, sin(angle), cos(angle), 0.0,
                        0, 0, 0.0, 1.0);
    return rotation;
}

mat4 _scale(float x, float y)
{
    mat4 scaling = mat4(x, 0.0, 0.0, 0.0,
                        0.0, y, 0.0, 0.0,
                        0.0, 0.0, 1.0, 0.0,
                        0.0, 0.0, 0.0, 1.0);
    return scaling;
}

mat4 sin_rot(float angle, float speed, float time){
    // mat4 rot = _rotateY(angle*time*speed);
    mat4 rot = _rotateY(angle);

    // rot = sin(angle * speed) * rot;
    return rot;
}

mat4 universal_rot = sin_rot(45, 0.51, iTime);

mat4 trans_fix_sin(float time)
{
  mat4 trans = _translate(0.25, abs(sin(time*15)/3), 0.6);
  // mat4 trans = _translate(0.25, 0.0, 0.6);
  return trans;
}

mat4 universal_trans = trans_fix_sin(iTime);

void drawWing(mat4 wing_offset, int created_quads)
{
  int offset = created_quads*6;
 int front_wing_pixels = 18;
 int side_wing_pixels = 6;
 int up_pixels = 3;
 int down_pixels = 3;
 int i_offset = 0;
 
 float sq_angle = radians(90.0);
 float wing_rotation_angle = radians(-50.0);

//  mat4 change = mat4(0.0);
mat4 change = _rotateZ(wing_rotation_angle);

 mat4 scaling = mat4(0.1, 0.0, 0.0, 0.0,
                    0.0, 0.1, 0.0, 0.0,
                    0.0, 0.0, 0.1, 0.0,
                    0.0, 0.0, 0.0, 1.0);

  //front side
  mat4 t_1 = _translate(0.2, 0.9, 0.0);
  mat4 r_front = _rotateZ(0.0);

  mat4 t_2 = _translate(0.0, 0.9, 0.0);
  mat4 t_3 = _translate(0.0, 0.7, 0.0);

  mat4 t_4 = _translate(-0.2, 0.9, 0.0);
  mat4 t_5 = _translate(-0.2, 0.7, 0.0);
  mat4 t_6 = _translate(-0.2, 0.5, 0.0);

  mat4 t_7 = _translate(0.2, 0.7, 0.0);
  mat4 t_8 = _translate(0.0, 0.5, 0.0);
  mat4 t_9 = _translate(-0.2, 0.3, 0.0);


  mat4 t_10 = _translate(0.2, 0.5, 0.0);
  mat4 t_11 = _translate(0.2, 0.3, 0.0);
  mat4 t_12 = _translate(0.0, 0.3, 0.0);
  mat4 t_13 = _translate(0.0, 0.1, 0.0);
  mat4 t_14 = _translate(-0.2, 0.1, 0.0);

  mat4 t_15 = _translate(0.2, 0.1, 0.0);
  mat4 t_16 = _translate(0.0, -0.1, 0.0);
  mat4 t_17 = _translate(-0.2, -0.1, 0.0);

  mat4 t_18 = _translate(0.2, -0.1, 0.0);

  mat4 translations_front[] = mat4[](
  t_1,t_2,t_3,t_4,t_5,t_6,t_7,t_8,t_9,t_10,t_11,t_12,t_13,
  t_14,t_15,t_16,t_17,t_18 
  );

  //right side
  mat4 t_19 = _translate(0.3, 0.9, -0.1);
  mat4 r_side = _rotateY(sq_angle);

  mat4 t_20 = _translate(0.3, 0.7, -0.1);
  mat4 t_21 = _translate(0.3, 0.5, -0.1);
  mat4 t_22 = _translate(0.3, 0.3, -0.1);

  mat4 t_23 = _translate(0.3, 0.1, -0.1);
  mat4 t_24 = _translate(0.3, -0.1, -0.1);

  mat4 translations_side_r[] = mat4[](
  t_19, t_20, t_21, t_22, t_23, t_24
  );

  mat4 t_25 = _translate(0.3-0.597, 0.9, -0.1);

  mat4 t_26 = _translate(0.3-0.597, 0.7, -0.1);
  mat4 t_27 = _translate(0.3-0.597, 0.5, -0.1);
  mat4 t_28 = _translate(0.3-0.597, 0.3, -0.1);

  mat4 t_29 = _translate(0.3-0.597, 0.1, -0.1);
  mat4 t_30 = _translate(0.3-0.597, -0.1, -0.1);

  mat4 translations_side_l[] = mat4[](
  t_25, t_26, t_27, t_28, t_29, t_30
  );

  //back side
  mat4 t_31 = _translate(0.2, 0.9, -0.197);

  mat4 t_32 = _translate(0.0, 0.9, -0.197);
  mat4 t_33 = _translate(0.0, 0.7, -0.197);

  mat4 t_34 = _translate(-0.2, 0.9, -0.197);
  mat4 t_35 = _translate(-0.2, 0.7, -0.197);
  mat4 t_36 = _translate(-0.2, 0.5, -0.197);

  mat4 t_37 = _translate(0.2, 0.7, -0.197);
  mat4 t_38 = _translate(0.0, 0.5, -0.197);
  mat4 t_39 = _translate(-0.2, 0.3, -0.197);


  mat4 t_40 = _translate(0.2, 0.5, -0.197);
  mat4 t_41 = _translate(0.2, 0.3, -0.197);
  mat4 t_42 = _translate(0.0, 0.3, -0.197);
  mat4 t_43 = _translate(0.0, 0.1, -0.197);
  mat4 t_44 = _translate(-0.2, 0.1, -0.197);

  mat4 t_45 = _translate(0.2, 0.1, -0.197);
  mat4 t_46 = _translate(0.0, -0.1, -0.197);
  mat4 t_47 = _translate(-0.2, -0.1, -0.197);

  mat4 t_48 = _translate(0.2, -0.1, -0.197);

  mat4 translations_back[] = mat4[](
  t_31, t_32, t_33, t_34, t_35, t_36, t_37, t_38, t_39, t_40,
  t_41, t_42, t_43, t_44, t_45, t_46, t_47, t_48
  );

  mat4 t_49 = _translate(0.2, 1.0, -0.1);
  
  mat4 r_down = _rotateX(sq_angle);

  mat4 t_50 = _translate(0.0, 1.0, -0.1);
  mat4 t_51 = _translate(-0.2, 1.0, -0.1);

  mat4 translations_up[] = mat4[](
  t_49, t_50, t_51
  );

  mat4 t_52 = _translate(0.2, 1.0-(6*0.2)+0.005, -0.1);

  mat4 t_53 = _translate(0.0, 1.0-(6*0.2)+0.005, -0.1);
  mat4 t_54 = _translate(-0.2, 1.0-(6*0.2)+0.005, -0.1);

  mat4 translations_down[] = mat4[](
  t_52, t_53, t_54
  );

  for (int i = 0; i <= front_wing_pixels; i++){
    if (translations_front[i] == 0) break;
    offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, translations_front[i], r_front, offset, i_offset+i+1);
  }

  i_offset += front_wing_pixels;

  for (int i = 0; i <= side_wing_pixels; i++){
    if (translations_side_r[i] == 0) break;
    offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, translations_side_r[i], r_side, offset, i_offset+i+1);
  }

  i_offset += side_wing_pixels;

  for (int i = 0; i <= side_wing_pixels; i++){
    if (translations_side_l[i] == 0) break;
    offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, translations_side_l[i], r_side, offset, i_offset+i+1);
  }

  i_offset += side_wing_pixels;

  // for (int i = 0; i <= front_wing_pixels; i++){
  //   if (translations_back[i] == 0) break;
  //   offset += drawQuad(wing_offset, change, scaling, translations_back[i], r_front, offset, i_offset+i+1);
  // }

  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_31, r_front, offset, i_offset+1);
  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_32, r_front, offset, i_offset+2);
  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_33, r_front, offset, i_offset+3);
  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_34, r_front, offset, i_offset+4);
  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_35, r_front, offset, i_offset+5);
  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_36, r_front, offset, i_offset+6);
  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_37, r_front, offset, i_offset+7);
  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_38, r_front, offset, i_offset+8);
  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_39, r_front, offset, i_offset+9);
  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_40, r_front, offset, i_offset+10);
  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_41, r_front, offset, i_offset+11);
  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_42, r_front, offset, i_offset+12);
  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_43, r_front, offset, i_offset+13);
  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_44, r_front, offset, i_offset+14);
  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_45, r_front, offset, i_offset+15);
  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_46, r_front, offset, i_offset+16);
  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_47, r_front, offset, i_offset+17);
  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_48, r_front, offset, i_offset+18);

  i_offset += front_wing_pixels;

  // for (int i = 0; i <= up_pixels; i++){
  //   if (translations_up[i] == 0) break;
  //   offset += drawQuad(wing_offset, change, scaling, translations_up[i], r_down, offset, i_offset+i+1);
  // }

  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_49, r_down, offset, i_offset+1);
  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_50, r_down, offset, i_offset+2);
  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_51, r_down, offset, i_offset+3);

  i_offset += up_pixels;

  // for (int i = 0; i <= down_pixels; i++){
  //   if (translations_down[i] == 0) break;
  //   offset += drawQuad(wing_offset, change, scaling, translations_down[i], r_down, offset, i_offset+i+1);
  // }

  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_52, r_down, offset, i_offset+1);
  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_53, r_down, offset, i_offset+2);
  offset += drawQuad(universal_trans, universal_rot, wing_offset, change, scaling, t_54, r_down, offset, i_offset+3);
}


void drawBody()
{
  int offset = 114*6;

  float body_height = 0.65;
  float body_length = 0.35-0.05;

  mat4 chest_whole_offset = _translate(0.18-0.1, 0.2, -0.9);

  float body_angle = radians(-35.0);
  mat4 chest_whole_rotate = _rotateZ(body_angle);

  mat4 s_bodyback = _scale(body_length, body_height);

  mat4 t_bodyback = _translate(0.0, 0.5, body_length);

  // mat4 r_chest = _rotateY(radians(0.0));
  // r_chest = r_chest * _rotateX(radians(0.0));

  mat4 r_bodyback = _rotateY(radians(90.0));

  offset += drawQuad(universal_trans, universal_rot, chest_whole_offset, chest_whole_rotate, s_bodyback, t_bodyback, r_bodyback, offset, 55);

  mat4 s_bodybottom = _scale(body_length, body_length);

  mat4 t_bodybottom = _translate(-body_length, 0.5-body_height, body_length);

  // mat4 r_chest = _rotateY(radians(0.0));
  // r_chest = r_chest * _rotateX(radians(0.0));

  mat4 r_bodybottom = _rotateY(radians(90.0));
  r_bodybottom = r_bodybottom * _rotateX(radians(90.0));

  offset += drawQuad(universal_trans, universal_rot, chest_whole_offset, chest_whole_rotate, s_bodybottom, t_bodybottom, r_bodybottom, offset, 55);


  mat4 s_chest = _scale(body_length, body_height);

  mat4 t_chest = _translate(0.0-body_length*2, 0.5,body_length);

  mat4 r_chest = _rotateY(radians(90.0));

  offset += drawQuad(universal_trans, universal_rot, chest_whole_offset, chest_whole_rotate, s_chest, t_chest, r_chest, offset, 55);

  mat4 s_bodytop = _scale(body_length, body_length);

  mat4 t_bodytop = _translate(-body_length, 0.5+body_height, body_length);

  // mat4 r_chest = _rotateY(radians(0.0));
  // r_chest = r_chest * _rotateX(radians(0.0));

  mat4 r_bodytop = _rotateY(radians(90.0));
  r_bodytop = r_bodytop * _rotateX(radians(90.0));

  offset += drawQuad(universal_trans, universal_rot, chest_whole_offset, chest_whole_rotate, s_bodytop, t_bodytop, r_bodytop, offset, 55);

  mat4 s_bodyleft = _scale(body_length, body_height);

  mat4 t_bodyleft = _translate(0.0-body_length, 0.5, body_length+body_length);

  mat4 r_bodyleft = _rotateY(radians(0.0));

  offset += drawQuad(universal_trans, universal_rot, chest_whole_offset, chest_whole_rotate, s_bodyleft, t_bodyleft, r_bodyleft, offset, 55);

  mat4 s_bodyright = _scale(body_length, body_height);

  mat4 t_bodyright = _translate(0.0-body_length, 0.5, body_length-body_length);

  mat4 r_bodyright = _rotateY(radians(0.0));

  offset += drawQuad(universal_trans, universal_rot, chest_whole_offset, chest_whole_rotate, s_bodyright, t_bodyright, r_bodyright, offset, 55);
}

void drawHead()
{
  int offset = 120*6;
  int lred = 56;
  int lpink = 57;
  int black = 58;
  int gray = 59;
  int lgray = 60;

  mat4 head_whole_offset = _translate(-0.6-0.11, 0.3+0.18, -0.6);

  mat4 head_whole_rotate = _rotateY(radians(90.0));

  mat4 crest_whole_rotate = _rotateY(radians(90.0));
  crest_whole_rotate = crest_whole_rotate * _rotateX(radians(10.0));

  mat4 crest_whole_offset = _translate(-0.95-0.11, 0.25+0.18, -0.6);

  mat4 scaling = mat4(0.1, 0.0, 0.0, 0.0,
                    0.0, 0.1, 0.0, 0.0,
                    0.0, 0.0, 0.1, 0.0,
                    0.0, 0.0, 0.0, 1.0);

  mat4 scaling_2 = mat4(0.07, 0.0, 0.0, 0.0,
                      0.0, 0.1, 0.0, 0.0,
                      0.0, 0.0, 0.1, 0.0,
                      0.0, 0.0, 0.0, 1.0);

  mat4 t_1 = _translate(0.2, 1.1, 0.0);
  mat4 t_2 = _translate(0.2, 0.9, 0.0);
  mat4 t_3 = _translate(0.2, 0.7, 0.0);
  mat4 t_4 = _translate(0.2, 1.1, 0.2);
  mat4 t_5 = _translate(0.2, 1.1, 0.4);
  mat4 t_6 = _translate(0.2, 1.1, 0.6);

  mat4 t_7 = _translate(0.2, 0.9, 0.2);
  mat4 t_8 = _translate(0.2, 0.7, 0.2);

  mat4 r_ = _rotateY(radians(90.0));

  mat4 t_9 = _translate(0.1, 0.9, 0.3);
  mat4 t_10 = _translate(0.1, 0.7, 0.3);

  mat4 t_11 = _translate(-0.1, 0.9, 0.3);
  mat4 t_12 = _translate(-0.1, 0.7, 0.3);

  mat4 r_in = _rotateZ(radians(90.0));

  mat4 t_13 = _translate(-0.1, 1.0, 0.4);
  mat4 t_14 = _translate(0.1, 1.0, 0.4);
  mat4 t_16 = _translate(-0.1, 1.0, 0.6);
  mat4 t_15 = _translate(0.1, 1.0, 0.6);

  mat4 r_up = _rotateX(radians(90.0));

  mat4 t_17 = _translate(0.2-0.4, 1.1, 0.0);
  mat4 t_18 = _translate(0.2-0.4, 0.9, 0.0);
  mat4 t_19 = _translate(0.2-0.4, 0.7, 0.0);
  mat4 t_20 = _translate(0.2-0.4, 1.1, 0.2);
  mat4 t_21 = _translate(0.2-0.4, 1.1, 0.4);
  mat4 t_22 = _translate(0.2-0.4, 1.1, 0.6);

  mat4 t_23 = _translate(0.2-0.4, 0.9, 0.2);
  mat4 t_24 = _translate(0.2-0.4, 0.7, 0.2);

  mat4 t_25 = _translate(0.2, 0.5, 0.0);
  mat4 t_26 = _translate(0.2, 0.5, 0.2);

  mat4 t_27 = _translate(0.2-0.4, 0.5, 0.0);
  mat4 t_28 = _translate(0.2-0.4, 0.5, 0.2);

  mat4 t_29 = _translate(0.1, 0.5, 0.3);
  mat4 t_30 = _translate(-0.1, 0.5, 0.3);

  mat4 t_31 = _translate(0.1, 0.5, -0.1);
  mat4 t_32 = _translate(-0.1, 0.5, -0.1);
  mat4 t_33 = _translate(0.1, 0.7, -0.1);
  mat4 t_34 = _translate(-0.1, 0.7, -0.1);
  mat4 t_35 = _translate(0.1, 0.9, -0.1);
  mat4 t_36 = _translate(-0.1, 0.9, -0.1);
  mat4 t_37 = _translate(0.1, 1.1, -0.1);
  mat4 t_38 = _translate(-0.1, 1.1, -0.1);

  mat4 t_39 = _translate(-0.1, 1.2, 0.4);
  mat4 t_40 = _translate(0.1, 1.2, 0.4);
  mat4 t_41 = _translate(-0.1, 1.2, 0.6);
  mat4 t_42 = _translate(0.1, 1.2, 0.6);

  mat4 t_43 = _translate(-0.1, 1.2, 0.2);
  mat4 t_44 = _translate(0.1, 1.2, 0.2);
  mat4 t_45 = _translate(-0.1, 1.2, 0.0);
  mat4 t_46 = _translate(0.1, 1.2, 0.0);

  mat4 t_47 = _translate(0.1, 1.1, 0.7);
  mat4 t_48 = _translate(-0.1, 1.1, 0.7);

  mat4 t_49 = _translate(-0.1, 0.4, 0.2);
  mat4 t_50 = _translate(0.1, 0.4, 0.2);
  mat4 t_51 = _translate(-0.1, 0.4, 0.0);
  mat4 t_52 = _translate(0.1, 0.4, 0.0);

  //head done ^

  mat4 t_53 = _translate(0.1, 0.9, 0.6);
  mat4 t_54 = _translate(-0.1, 0.9, 0.6);

  mat4 t_55 = _translate(-0.1, 0.9, 0.4);
  mat4 t_56 = _translate(0.1, 0.9, 0.4);

  mat4 t_57 = _translate(0.0, 0.9, 0.7);

  mat4 t_58 = _translate(0.0, 0.8, 0.6);
  mat4 t_59 = _translate(0.0, 0.8, 0.4);

  mat4 t_60 = _translate(-0.1, 0.7, 0.6);
  mat4 t_61 = _translate(0.1, 0.7, 0.6);

  mat4 t_62 = _translate(0.0, 0.7, 0.7);

  mat4 t_63 = _translate(0.0, 0.6, 0.6);

  mat4 t_64 = _translate(0.0, 0.7, 0.5);

  mat4 t_65 = _translate(-0.07, 0.7, 0.4);
  mat4 t_66 = _translate(0.07, 0.7, 0.4);

  mat4 t_67 = _translate(0.0, 0.6, 0.4);

  //beak done ^

  mat4 t_68 = _translate(0.0, 1.3, 0.0);
  mat4 t_69 = _translate(0.0, 1.3, 0.2);

  mat4 t_70 = _translate(0.0, 1.5, -0.2);
  mat4 t_71 = _translate(0.0, 1.5, 0.2);

  mat4 t_72 = _translate(0.0, 1.7, -0.4);
  mat4 t_73 = _translate(0.0, 1.7, 0.0);

  mat4 t_74 = _translate(0.0, 1.9, -0.4);
  mat4 t_75 = _translate(0.0, 1.9, 0.0);

  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_1, r_, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_2, r_, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_3, r_, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_4, r_, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_5, r_, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_6, r_, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_7, r_, offset, gray);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_8, r_, offset, lpink);

  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_9, r_in, offset, lpink);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_10, r_in, offset, lpink);

  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_11, r_in, offset, lpink);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_12, r_in, offset, lpink);

  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_13, r_up, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_14, r_up, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_15, r_up, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_16, r_up, offset, lred);

  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_17, r_, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_18, r_, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_19, r_, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_20, r_, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_21, r_, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_22, r_, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_23, r_, offset, gray);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_24, r_, offset, lpink);

  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_25, r_, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_26, r_, offset, lred);

  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_27, r_, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_28, r_, offset, lred);

  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_29, r_in, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_30, r_in, offset, lred);

  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_31, r_in, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_32, r_in, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_33, r_in, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_34, r_in, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_35, r_in, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_36, r_in, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_37, r_in, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_38, r_in, offset, lred);

  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_39, r_up, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_40, r_up, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_41, r_up, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_42, r_up, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_43, r_up, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_44, r_up, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_45, r_up, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_46, r_up, offset, lred);

  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_47, r_in, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_48, r_in, offset, lred);

  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_49, r_up, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_50, r_up, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_51, r_up, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_52, r_up, offset, lred);

  //head done ^

  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_53, r_, offset, black);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_54, r_, offset, black);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_55, r_, offset, black);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_56, r_, offset, black);

  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_57, r_in, offset, black);

  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_58, r_up, offset, black);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_59, r_up, offset, black);

  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_60, r_, offset, gray);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_61, r_, offset, gray);

  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_62, r_in, offset, gray);

  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_63, r_up, offset, gray);

  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_64, r_in, offset, gray);

  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_65, r_, offset, lgray);
  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling, t_66, r_, offset, lgray);

  offset += drawQuad(universal_trans, universal_rot, head_whole_offset, head_whole_rotate, scaling_2, t_67, r_up, offset, lgray);

  //beak done ^

  offset += drawQuad(universal_trans, universal_rot, crest_whole_offset, crest_whole_rotate, scaling, t_68, r_, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, crest_whole_offset, crest_whole_rotate, scaling, t_69, r_, offset, lred);

  offset += drawQuad(universal_trans, universal_rot, crest_whole_offset, crest_whole_rotate, scaling, t_70, r_, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, crest_whole_offset, crest_whole_rotate, scaling, t_71, r_, offset, lred);

  offset += drawQuad(universal_trans, universal_rot, crest_whole_offset, crest_whole_rotate, scaling, t_72, r_, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, crest_whole_offset, crest_whole_rotate, scaling, t_73, r_, offset, lred);

  offset += drawQuad(universal_trans, universal_rot, crest_whole_offset, crest_whole_rotate, scaling, t_74, r_, offset, lred);
  offset += drawQuad(universal_trans, universal_rot, crest_whole_offset, crest_whole_rotate, scaling, t_75, r_, offset, lred);
}


void drawTail()
{
  int offset = 213*6;

  int red = 62;
  int yellow = 63;
  int lblue = 64;
  int blue = 65;

  mat4 tail_whole_offset = _translate(0.03, 0.03, -0.31);

  mat4 tail_whole_rotate = _rotateZ(radians(25.0));

  mat4 scaling = _scale(0.1, 0.1);

  mat4 r_ = _rotateX(radians(0.0));

  mat4 r_up = _rotateX(radians(90.0));

  mat4 r_in = _rotateY(radians(90.0));

  mat4 t_1 = _translate(0.0, 0.0, 0.0);
  mat4 t_2 = _translate(0.2, 0.0, 0.0);
  mat4 t_3 = _translate(0.4, 0.0, 0.0);
  mat4 t_4 = _translate(0.6, 0.0, 0.0);

  mat4 t_5 = _translate(0.0, 0.1, -0.1);
  mat4 t_6 = _translate(0.2, 0.1, -0.1);
  mat4 t_7 = _translate(0.4, 0.1, -0.1);
  mat4 t_8 = _translate(0.6, 0.1, -0.1);

  mat4 t_9 = _translate(0.0, 0.1, -0.3);
  mat4 t_10 = _translate(0.2, 0.1, -0.3);
  mat4 t_11 = _translate(0.4, 0.1, -0.3);
  mat4 t_12 = _translate(0.6, 0.1, -0.3);

  mat4 t_13 = _translate(0.0, 0.1, -0.5);
  mat4 t_14 = _translate(0.2, 0.1, -0.5);
  mat4 t_15 = _translate(0.4, 0.1, -0.5);
  mat4 t_16 = _translate(0.6, 0.1, -0.5);

  mat4 t_17 = _translate(0.0, 0.0, -0.6);
  mat4 t_18 = _translate(0.2, 0.0, -0.6);
  mat4 t_19 = _translate(0.4, 0.0, -0.6);
  mat4 t_20 = _translate(0.6, 0.0, -0.6);

  mat4 t_21 = _translate(-0.1, 0.0, -0.1);
  mat4 t_22 = _translate(-0.1, 0.0, -0.3);
  mat4 t_23 = _translate(-0.1, 0.0, -0.5);

  mat4 t_24 = _translate(0.7, 0.0, -0.1);
  mat4 t_25 = _translate(0.7, 0.0, -0.3);
  mat4 t_26 = _translate(0.7, 0.0, -0.5);

  mat4 t_27 = _translate(0.0, 0.1-0.2, -0.1);
  mat4 t_28 = _translate(0.2, 0.1-0.2, -0.1);
  mat4 t_29 = _translate(0.4, 0.1-0.2, -0.1);
  mat4 t_30 = _translate(0.6, 0.1-0.2, -0.1);

  mat4 t_31 = _translate(0.0, 0.1-0.2, -0.3);
  mat4 t_32 = _translate(0.2, 0.1-0.2, -0.3);
  mat4 t_33 = _translate(0.4, 0.1-0.2, -0.3);
  mat4 t_34 = _translate(0.6, 0.1-0.2, -0.3);

  mat4 t_35 = _translate(0.0, 0.1-0.2, -0.5);
  mat4 t_36 = _translate(0.2, 0.1-0.2, -0.5);
  mat4 t_37 = _translate(0.4, 0.1-0.2, -0.5);
  mat4 t_38 = _translate(0.6, 0.1-0.2, -0.5);

  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_1, r_, offset, red);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_2, r_, offset, yellow);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_3, r_, offset, lblue);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_4, r_, offset, blue);

  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_5, r_up, offset, red);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_6, r_up, offset, yellow);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_7, r_up, offset, lblue);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_8, r_up, offset, blue);

  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_9, r_up, offset, red);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_10, r_up, offset, red);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_11, r_up, offset, yellow);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_12, r_up, offset, lblue);

  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_13, r_up, offset, red);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_14, r_up, offset, yellow);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_15, r_up, offset, lblue);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_16, r_up, offset, blue);

  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_17, r_, offset, red);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_18, r_, offset, yellow);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_19, r_, offset, lblue);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_20, r_, offset, blue);

  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_21, r_in, offset, red);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_22, r_in, offset, red);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_23, r_in, offset, red);

  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_24, r_in, offset, blue);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_25, r_in, offset, lblue);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_26, r_in, offset, blue);

  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_27, r_up, offset, red);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_28, r_up, offset, yellow);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_29, r_up, offset, lblue);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_30, r_up, offset, blue);

  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_31, r_up, offset, red);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_32, r_up, offset, red);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_33, r_up, offset, yellow);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_34, r_up, offset, lblue);

  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_35, r_up, offset, red);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_36, r_up, offset, yellow);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_37, r_up, offset, lblue);
  offset += drawQuad(universal_trans, universal_rot, tail_whole_offset, tail_whole_rotate, scaling, t_38, r_up, offset, blue);
}

void drawLegs()
{
  int offset = 195*6;

  int skin = 61;

  float leg_length = 0.02;

  mat4 leg_whole_offset = _translate(-0.25, -0.4, -0.31);
  mat4 leg_whole_rotate = _rotateX(radians(0.0));

  mat4 leg_side_scale = _scale(leg_length, 0.25);

  mat4 leg_front_scale = _scale(0.1, 0.25);

  mat4 leg_feet_scale = _scale(0.1, leg_length);

  mat4 leg_updown_scale = _scale(0.1, 0.1);

  mat4 r_ = _rotateX(radians(0.0));

  mat4 r_in = _rotateY(radians(90.0));

  mat4 r_up = _rotateX(radians(90.0));

  mat4 t_1 = _translate(0.0, 0.0, 0.0);
  mat4 t_2 = _translate(0.0, 0.0, -0.2);

  mat4 t_3 = _translate(0.0, 0.0, 0.0-0.48+0.1);
  mat4 t_4 = _translate(0.0, 0.0, -0.2-0.48+0.1);

  mat4 t_5 = _translate(0.0-leg_length, 0.0, -0.1);
  mat4 t_6 = _translate(0.0+leg_length, 0.0, -0.1);

  mat4 t_7 = _translate(0.0-leg_length, 0.0, -0.1-0.48+0.1);
  mat4 t_8 = _translate(0.0+leg_length, 0.0, -0.1-0.48+0.1);

  mat4 t_9 = _translate(-0.1, -0.48+0.25, 0.0);
  mat4 t_10 = _translate(-0.1, -0.48+0.25, -0.2);
  mat4 t_11 = _translate(-0.1, -0.48+0.25, 0.0-0.48+0.1);
  mat4 t_12 = _translate(-0.1, -0.48+0.25, -0.2-0.48+0.1);

  mat4 t_13 = _translate(-0.2, -0.48+0.25, -0.1);
  mat4 t_14 = _translate(-0.2, -0.48+0.25, -0.1-0.48+0.1);

  mat4 t_15 = _translate(-0.2+0.1, -0.48+0.25+leg_length, -0.1);
  mat4 t_16 = _translate(-0.2+0.1, -0.48+0.25+leg_length, -0.1-0.48+0.1);

  mat4 t_17 = _translate(-0.2+0.1, -0.48+0.25-leg_length, -0.1);
  mat4 t_18 = _translate(-0.2+0.1, -0.48+0.25-leg_length, -0.1-0.48+0.1);
  // mat4 t_10 = _translate(0.0, 0.0, -0.1-0.48-0.48-0.2);

  offset += drawQuad(universal_trans, universal_rot, leg_whole_offset, leg_whole_rotate, leg_side_scale, t_1, r_, offset, skin);
  offset += drawQuad(universal_trans, universal_rot, leg_whole_offset, leg_whole_rotate, leg_side_scale, t_2, r_, offset, skin);

  offset += drawQuad(universal_trans, universal_rot, leg_whole_offset, leg_whole_rotate, leg_side_scale, t_3, r_, offset, skin);
  offset += drawQuad(universal_trans, universal_rot, leg_whole_offset, leg_whole_rotate, leg_side_scale, t_4, r_, offset, skin);

  offset += drawQuad(universal_trans, universal_rot, leg_whole_offset, leg_whole_rotate, leg_front_scale, t_5, r_in, offset, skin);
  offset += drawQuad(universal_trans, universal_rot, leg_whole_offset, leg_whole_rotate, leg_front_scale, t_6, r_in, offset, skin);

  offset += drawQuad(universal_trans, universal_rot, leg_whole_offset, leg_whole_rotate, leg_front_scale, t_7, r_in, offset, skin);
  offset += drawQuad(universal_trans, universal_rot, leg_whole_offset, leg_whole_rotate, leg_front_scale, t_8, r_in, offset, skin);

  offset += drawQuad(universal_trans, universal_rot, leg_whole_offset, leg_whole_rotate, leg_feet_scale, t_9, r_, offset, skin);
  offset += drawQuad(universal_trans, universal_rot, leg_whole_offset, leg_whole_rotate, leg_feet_scale, t_10, r_, offset, skin);
  offset += drawQuad(universal_trans, universal_rot, leg_whole_offset, leg_whole_rotate, leg_feet_scale, t_11, r_, offset, skin);
  offset += drawQuad(universal_trans, universal_rot, leg_whole_offset, leg_whole_rotate, leg_feet_scale, t_12, r_, offset, skin);

  offset += drawQuad(universal_trans, universal_rot, leg_whole_offset, leg_whole_rotate, leg_feet_scale, t_13, r_in, offset, skin);
  offset += drawQuad(universal_trans, universal_rot, leg_whole_offset, leg_whole_rotate, leg_feet_scale, t_14, r_in, offset, skin);

  offset += drawQuad(universal_trans, universal_rot, leg_whole_offset, leg_whole_rotate, leg_updown_scale, t_15, r_up, offset, skin);
  offset += drawQuad(universal_trans, universal_rot, leg_whole_offset, leg_whole_rotate, leg_updown_scale, t_16, r_up, offset, skin);

  offset += drawQuad(universal_trans, universal_rot, leg_whole_offset, leg_whole_rotate, leg_updown_scale, t_17, r_up, offset, skin);
  offset += drawQuad(universal_trans, universal_rot, leg_whole_offset, leg_whole_rotate, leg_updown_scale, t_18, r_up, offset, skin);
}

 void main(){
  mat4 first_wing_offset = _translate(-0.07, 0.2, -0.1);
  mat4 sec_wing_offset = _translate(-0.07, 0.2, -0.9);
  drawWing(first_wing_offset, 0);
  drawWing(sec_wing_offset, 57);

  drawBody();

  drawHead();
  
  drawLegs();

  drawTail();  

 }
 #endif
  
  
  
 #ifdef FRAGMENT_SHADER
 precision highp float;
  
uniform float iTime;

flat in int vM;
in vec2 vCoord;

 out vec4 fColor;
  
 void main(){
  // vec3(0xBC,0x00,0x2D)/vec3(255)
  vec4 LightRed = vec4(0xe3,0x3b,0x3b,0xff)/vec4(255);
  vec4 LightYellow = vec4(0xff,0xff,0x78,0xff)/vec4(255);
  vec4 LightBlue = vec4(0x61,0x71,0xff,0xff)/vec4(255);
  vec4 Blue = vec4(0x56,0x51,0xff,0xff)/vec4(255);
  vec4 LightPink = vec4(0xfe,0xcc,0xc2,0xff)/vec4(255);
  vec4 Gray = vec4(0x3e,0x3f,0x3f,0xff)/vec4(255);
  vec4 LightGray = vec4(0x6a,0x6a,0x6a,0xff)/vec4(255);
  vec4 Black = vec4(0x27,0x28,0x28,0xff)/vec4(255); 
  vec4 Skin = vec4(0xd8,0xb8,0xb3,0xff)/vec4(255);

  //front side
  if (vM==1) fColor = LightRed;
  if (vM==2) fColor = LightRed;
  if (vM==3) fColor = LightRed;
  if (vM==4) fColor = LightRed;
  if (vM==5) fColor = LightRed;
  if (vM==6) fColor = LightRed;
  if (vM==7) fColor = LightRed;
  if (vM==8) fColor = LightRed;
  if (vM==9) fColor = LightRed;

  if (vM==10) fColor = LightYellow;
  if (vM==11) fColor = LightYellow;
  if (vM==12) fColor = LightYellow;
  if (vM==13) fColor = LightYellow;
  if (vM==14) fColor = LightYellow;

  if (vM==15) fColor = LightBlue;
  if (vM==16) fColor = LightBlue;
  if (vM==17) fColor = LightBlue;

  if (vM==18) fColor = Blue;

  //right side
  if (vM==19) fColor = LightRed;
  if (vM==20) fColor = LightRed;

  if (vM==21) fColor = LightYellow;
  if (vM==22) fColor = LightYellow;

  if (vM==23) fColor = LightBlue;

  if (vM==24) fColor = Blue;

  //left side
  if (vM==25) fColor = LightRed;
  if (vM==26) fColor = LightRed;
  if (vM==27) fColor = LightRed;
  if (vM==28) fColor = LightRed;

  if (vM==29) fColor = LightYellow;

  if (vM==30) fColor = LightBlue;
  if (vM==31) fColor = LightBlue;

  //front side
  for (int i = 31; i <= 39; i++){
    if (vM==i) fColor = LightRed;
  }

  for (int i = 40; i <= 44; i++){
    if (vM==i) fColor = LightYellow;
  }

  for (int i = 45; i <= 47; i++){
    if (vM==i) fColor = LightBlue;
  }

  if (vM==48) fColor = Blue;

  //up side
  if (vM==49) fColor = LightRed;
  if (vM==50) fColor = LightRed;
  if (vM==51) fColor = LightRed;

  //down side
  if (vM==52) fColor = Blue;
  if (vM==53) fColor = LightBlue;
  if (vM==54) fColor = LightBlue;

  //body
  if (vM==55) fColor = LightRed;

  //head
  if (vM==56) fColor = LightRed;
  if (vM==57) fColor = LightPink;
  if (vM==58) fColor = Black;
  if (vM==59) fColor = Gray;
  if (vM==60) fColor = LightGray;

  //legs
  if (vM==61) fColor = Skin;


  //tail
  if (vM==62) fColor = LightRed;
  if (vM==63) fColor = LightYellow;
  if (vM==64) fColor = LightBlue;
  if (vM==65) fColor = Blue;

 }
  
 #endif