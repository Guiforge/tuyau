from collections.abc import Callable  # noqa: D100
from typing import Any, Generic, TypeVar, overload

_START = TypeVar("_START")
_T1 = TypeVar("_T1")
_T2 = TypeVar("_T2")
_T3 = TypeVar("_T3")
_T4 = TypeVar("_T4")
_END = TypeVar("_END")

# @overload
# class Tube:

class Tube(Generic[_START, _END]):  # noqa: D101
    @overload
    def __init__(self, _callable: Callable[[_START], _END]) -> None: ...  # noqa: ANN101
    @overload
    def __init__(
        self,  # noqa: ANN101
        _callable1: Callable[[_START], _T1],
        _callable2: Callable[[_T1], _END],
    ) -> None: ...
    @overload
    def __init__(
        self,  # noqa: ANN101
        _callable1: Callable[[_START], _T1],
        _callable2: Callable[[_T1], _T2],
        _callable3: Callable[[_T2], _END],
    ) -> None: ...
    @overload
    def __init__(
        self,  # noqa: ANN101
        _callable1: Callable[[_START], _T1],
        _callable2: Callable[[_T1], _T2],
        _callable3: Callable[[_T2], _T3],
        _callable4: Callable[[_T3], _END],
    ) -> None: ...
    @overload
    def __init__(
        self,  # noqa: ANN101
        _callable1: Callable[[_START], _T1],
        _callable2: Callable[[_T1], _T2],
        _callable3: Callable[[_T2], _T3],
        _callable4: Callable[[_T3], _T4],
        _callable5: Callable[[_T4], _END],
    ) -> None: ...
    @overload
    def __init__(self, *args: Callable[[Any], Any]) -> None: ...  # noqa: ANN101
    @overload
    def __call__(self, value: _START) -> _END: ...  # noqa: ANN101
    @overload
    def __call__(self, value: Any) -> Any: ...  # noqa: ANN101, ANN401
    @overload
    def send(self, value: _START) -> _END: ...  # noqa: ANN101
    @overload
    def send(self, value: Any) -> Any: ...  # noqa: ANN101, ANN401
