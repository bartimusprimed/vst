module linux
import os

fn parse_ip_output(result os.Result) ?[]string {
	if result.exit_code != 0 {
		return error("linux: GET IP FAILED")
	}
	mut detected_ips := []string{}
	for line in result.output.split_into_lines() {
		for mut entry in line.split("  ") {
		if entry.starts_with("inet") {
			entry = entry.split(" ")[1]
			if entry.contains(":") {
				continue
			}
			detected_ips << entry
		}
		}
	}
	println(detected_ips)
	return detected_ips
}

pub fn get_ip_addresses() ?[]string {
	return parse_ip_output(os.execute("ifconfig -a"))
}