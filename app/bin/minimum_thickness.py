#!/usr/bin/env python

"""
Print the minimum transmission required to achieve a level of noise in the
differential phase signal.

"""

import numpy as np
from scipy import optimize
import argparse


def df(a, beta):
    """Theoretical value of the dark field corresponding to an absorption a

    :beta: parameter from the fit
    :a: absorption
    :returns: dark field

    """
    gamma = np.pi ** 3 / 3 * beta / (1 - 2 * np.pi * beta)
    return np.exp(gamma * (1 - 1 / a))


def sigma(a, v, n, beta):
    """Theoretical value for the noise of the differential phase signal

    :a: absorption
    :v: flat visibility
    :n: flat counts
    :beta: parameter from the fit
    :returns: @todo

    """
    return 1 / (v * np.sqrt(n * a) * df(a, beta))

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        __doc__,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument(
        "--sigma_max",
        nargs="?", type=float,
        default=1.25,
        help="error threshold")
    parser.add_argument(
        "--visibility",
        nargs="?", type=float,
        default=0.1,
        help="flat visibility")
    parser.add_argument(
        "--counts",
        nargs="?", type=float,
        default=10000,
        help="flat photon counts")
    parser.add_argument(
        "--beta",
        nargs="?", type=float,
        default=0.08,
        help="fit parameter from dark field data")
    args = parser.parse_args()
    sigma_max = args.sigma_max
    v = args.visibility
    n = args.counts
    beta = args.beta

    def optimization_function(a):
        return sigma(a, v, n, beta) - sigma_max

    minimum_transmission = optimize.bisect(
        optimization_function,
        0.01,
        0.99,
        maxiter=100000)
    print(minimum_transmission)
