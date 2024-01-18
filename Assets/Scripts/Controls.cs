using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Controls : MonoBehaviour
{
    KeyCode[][] controls = new KeyCode[][]
    {
        new KeyCode[] { KeyCode.Keypad7, KeyCode.Q, KeyCode.P },
        new KeyCode[] { KeyCode.Keypad8, KeyCode.W, KeyCode.LeftBracket },
        new KeyCode[] { KeyCode.Keypad9, KeyCode.E, KeyCode.RightBracket },
        new KeyCode[] { KeyCode.Keypad4, KeyCode.A, KeyCode.L },
        new KeyCode[] { KeyCode.Keypad5, KeyCode.S, KeyCode.Semicolon },
        new KeyCode[] { KeyCode.Keypad6, KeyCode.D, KeyCode.Quote },
        new KeyCode[] { KeyCode.Keypad1, KeyCode.Z, KeyCode.Comma },
        new KeyCode[] { KeyCode.Keypad2, KeyCode.X, KeyCode.Period },
        new KeyCode[] { KeyCode.Keypad3, KeyCode.C, KeyCode.Slash }
    };

    private void FixedUpdate()
    {
        for (int i = 0; i < controls.Length; i++)
        {
            GameObject strum = GetComponent<Transform>().GetChild(i).gameObject;
            SpriteRenderer sprite = strum.GetComponent<SpriteRenderer>();

            bool justPressed = false;
            bool pressed = false;
            bool justReleased = false;

            for (int j = 0; i < controls[i].Length; j++)
            {
                if (Input.GetKeyDown(controls[i][j]))
                    justPressed = true;
                if (Input.GetKey(controls[i][j]))
                    pressed = true;
                if (Input.GetKeyUp(controls[i][j]))
                    justReleased = true;
            }

            if (pressed)
            {
                Debug.Log("press " + i);
                sprite.color = new Color(255, 70, 63);
            }
            else
            {
                sprite.color = Color.white;
            }
        }
    }
}
