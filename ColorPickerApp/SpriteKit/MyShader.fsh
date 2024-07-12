//
//  MyShader.fsh
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/06/13.
//

void main() {
    // 色を用意する
    vec4 yellow = vec4(0.99, 0.83, 0.46, 1.0);
    // 黄色を出力する
    gl_FragColor = yellow;
}
