using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.HighDefinition;

public class DayCycleController : MonoBehaviour {

    [Range(0, 24)]
    [SerializeField] private float timeOfDay;
    [SerializeField] private Light moon;
    [SerializeField] private Light sun;
    [SerializeField] private float orbitSpeed = 1.0f;
    [SerializeField] private bool isNight;
    [SerializeField] private Volume skyVolume;
    [SerializeField] private AnimationCurve starsCurve;
    private PhysicallyBasedSky sky;

    // Start is called before the first frame update
    private void Start() {
        skyVolume.profile.TryGet<PhysicallyBasedSky>(out sky);
    }

    // Update is called once per frame
    private void Update() {
        timeOfDay += Time.deltaTime * orbitSpeed;
        if (timeOfDay > 24) {
            timeOfDay = 0;
        }
        UpdateTime();

    }

    private void OnValidate() {
        skyVolume.profile.TryGet<PhysicallyBasedSky>(out sky);
        UpdateTime();
    }

    private void UpdateTime() {
        float alpha = timeOfDay / 24.0f;
        float sunRotation = Mathf.Lerp(-90, 270, alpha);
        float moonRotation = sunRotation - 180;
        sun.transform.rotation = Quaternion.Euler(sunRotation, 0, 0);
        moon.transform.rotation = Quaternion.Euler(moonRotation, 0, 0);
        sky.spaceEmissionMultiplier.value = starsCurve.Evaluate(alpha) * 1500.0f;

        CheckNightDayTransition();
    }

    private void CheckNightDayTransition() {
        if (isNight) {
            if (moon.transform.rotation.eulerAngles.x > 180) {
                StartDay();
            }
        } else {
            if (sun.transform.rotation.eulerAngles.x > 180) {
                StartNight();
            }
        }
    }

    private void StartDay() {
        isNight = false;
        sun.shadows = LightShadows.Soft;
        moon.shadows = LightShadows.None;
    }

    private void StartNight() {
        sun.shadows = LightShadows.None;
        moon.shadows = LightShadows.Soft;
    }
}