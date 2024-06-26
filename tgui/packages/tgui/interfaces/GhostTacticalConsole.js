// NSV13

import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Button, Section, ProgressBar, LabeledList } from '../components';
import { Window } from '../layouts';

export const GhostTacticalConsole = (props, context) => {
  const { act, data } = useBackend(context);
  const tabIndex = 1;
  return (
    <Window
      resizable
      theme="hackerman"
      width={560}
      height={600}>
      <Window.Content scrollable>
        <Section>
          <Section title="Ship status">
            <Section title="Hull integrity:">
              <ProgressBar
                value={(data.integrity / data.max_integrity * 100) * 0.01}
                ranges={{
                  good: [0.95, Infinity],
                  average: [0.15, 0.9],
                  bad: [-Infinity, 0.15],
                }} />
            </Section>
            <Section title="Armour:">
              {data.has_quadrant && (
                <LabeledList>
                  <LabeledList.Item label="Forward Port">
                    <ProgressBar
                      value={(data.quadrant_fp_armour_current / data.quadrant_fp_armour_max)}
                      ranges={{
                        good: [0.66, Infinity],
                        average: [0.33, 0.66],
                        bad: [-Infinity, 0.33],
                      }} />
                  </LabeledList.Item>
                  <LabeledList.Item label="Forward Starboard">
                    <ProgressBar
                      value={(data.quadrant_fs_armour_current / data.quadrant_fs_armour_max)}
                      ranges={{
                        good: [0.66, Infinity],
                        average: [0.33, 0.66],
                        bad: [-Infinity, 0.33],
                      }} />
                  </LabeledList.Item>
                  <LabeledList.Item label="Aft Port">
                    <ProgressBar
                      value={(data.quadrant_ap_armour_current / data.quadrant_ap_armour_max)}
                      ranges={{
                        good: [0.66, Infinity],
                        average: [0.33, 0.66],
                        bad: [-Infinity, 0.33],
                      }} />
                  </LabeledList.Item>
                  <LabeledList.Item label="Aft Starboard">
                    <ProgressBar
                      value={(data.quadrant_as_armour_current / data.quadrant_as_armour_max)}
                      ranges={{
                        good: [0.66, Infinity],
                        average: [0.33, 0.66],
                        bad: [-Infinity, 0.33],
                      }} />
                  </LabeledList.Item>
                </LabeledList>
              ) || (
                <LabeledList>
                  <LabeledList.Item label="Integrity">
                    <ProgressBar
                      value={(data.armour_integrity / data.max_armour_integrity * 100) * 0.01}
                      ranges={{
                        good: [0.9, Infinity],
                        average: [0.15, 0.9],
                        bad: [-Infinity, 0.15],
                      }} />
                  </LabeledList.Item>
                </LabeledList>
              )}
            </Section>
          </Section>
          <Section title="Armaments:">
            <LabeledList>
              <LabeledList.Item label="Light Munitions">
                <ProgressBar
                  value={(data.light_ammo / data.light_ammo_max)}
                  ranges={{
                    good: [0.66, Infinity],
                    average: [0.33, 0.66],
                    bad: [-Infinity, 0.33],
                  }} />
              </LabeledList.Item>
              <LabeledList.Item label="Heavy Munitions">
                <ProgressBar
                  value={(data.heavy_ammo / data.heavy_ammo_max)}
                  ranges={{
                    good: [0.66, Infinity],
                    average: [0.33, 0.66],
                    bad: [-Infinity, 0.33],
                  }} />
              </LabeledList.Item>
              <LabeledList.Item label="Missiles">
                <ProgressBar
                  value={(data.missile_ammo / data.missile_ammo_max)}
                  ranges={{
                    good: [0.66, Infinity],
                    average: [0.33, 0.66],
                    bad: [-Infinity, 0.33],
                  }} />
              </LabeledList.Item>
              <LabeledList.Item label="Torpedoes">
                <ProgressBar
                  value={(data.torpedo_ammo / data.torpedo_ammo_max)}
                  ranges={{
                    good: [0.66, Infinity],
                    average: [0.33, 0.66],
                    bad: [-Infinity, 0.33],
                  }} />
              </LabeledList.Item>
            </LabeledList>
          </Section>
          <Section title="Tracking:">
            {!data.no_gun_cam && (
              <Button
                width="100%"
                fluid
                content={"Toggle Gun Camera"}
                icon="bullseye"
                onClick={() => act('toggle_gun_camera')} />)}
            {Object.keys(data.painted_targets).map((key, newCurrent) => {
              let value = data.painted_targets[key];
              const [current, setCurrent] = useLocalState(context, 'fs_current', true);
              const [hidden, setHidden] = useLocalState(context, 'fs_hidden', true);

              return (
                <Fragment key={key}>
                  {!!value.name && (
                    <Section>
                      <Button
                        width="100%"
                        fluid
                        onClick={() => {
                          setCurrent(value.name);
                          setHidden(!hidden);
                        }}>
                        {`${value.name}`}
                      </Button>
                      {!!(current === value.name) && !hidden && (
                        <Section title="Armour">
                          <LabeledList>
                            <LabeledList.Item label="Forward Starboard">
                              <ProgressBar
                                value={(
                                  value.quadrant_fp_armour_current / value.quadrant_fp_armour_max * 100) * 0.01}
                                ranges={{
                                  good: [0.95, Infinity],
                                  average: [0.15, 0.9],
                                  bad: [-Infinity, 0.15],
                                }} />
                            </LabeledList.Item>
                            <LabeledList.Item label="Forward Port">
                              <ProgressBar
                                value={(
                                  value.quadrant_fs_armour_current / value.quadrant_fs_armour_max * 100) * 0.01}
                                ranges={{
                                  good: [0.95, Infinity],
                                  average: [0.15, 0.9],
                                  bad: [-Infinity, 0.15],
                                }} />
                            </LabeledList.Item>
                            <LabeledList.Item label="Aft Starboard">
                              <ProgressBar
                                value={(
                                  value.quadrant_as_armour_current / value.quadrant_as_armour_max * 100) * 0.01}
                                ranges={{
                                  good: [0.95, Infinity],
                                  average: [0.15, 0.9],
                                  bad: [-Infinity, 0.15],
                                }} />
                            </LabeledList.Item>
                            <LabeledList.Item label="Aft Port">
                              <ProgressBar
                                value={(
                                  value.quadrant_ap_armour_current / value.quadrant_ap_armour_max * 100) * 0.01}
                                ranges={{
                                  good: [0.95, Infinity],
                                  average: [0.15, 0.9],
                                  bad: [-Infinity, 0.15],
                                }} />
                            </LabeledList.Item>
                          </LabeledList>
                        </Section>
                      )}
                      <Section>
                        <LabeledList>
                          <LabeledList.Item label="Integrity">
                            <ProgressBar
                              value={(
                                value.integrity / value.max_integrity * 100) * 0.01}
                              ranges={{
                                good: [0.95, Infinity],
                                average: [0.15, 0.9],
                                bad: [-Infinity, 0.15],
                              }} />
                          </LabeledList.Item>
                        </LabeledList>
                      </Section>
                      <Button
                        fluid
                        content={data.target_name === value.name ? `Stop Targeting ${value.name}` : `Target ${value.name}`}
                        icon="bullseye"
                        onClick={() =>
                          act('lock_ship', { target: value.name })} />
                      <Button
                        fluid
                        content={`Stop Tracking ${value.name}`}
                        icon="bullseye"
                        onClick={() =>
                          act('dump_lock', { target: value.name })} />
                    </Section>
                  )}
                </Fragment>);
            })}
          </Section>
        </Section>
      </Window.Content>
    </Window>
  );
};
