﻿//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-05-22 (#3713)
Функция ПолучитьСписокСтатейРеглСоответствующихСтатьеОборотов(СтатьяОборотов) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	бит_СтатьиОборотов_СтатьиРегл.СтатьяРегл КАК СтатьяРегл
		|ИЗ
		|	РегистрСведений.бит_СтатьиОборотов_СтатьиРегл КАК бит_СтатьиОборотов_СтатьиРегл
		|ГДЕ
		|	бит_СтатьиОборотов_СтатьиРегл.СтатьяОборотов = &СтатьяОборотов
		|
		|СГРУППИРОВАТЬ ПО
		|	бит_СтатьиОборотов_СтатьиРегл.СтатьяРегл";
	
	Запрос.УстановитьПараметр("СтатьяОборотов", СтатьяОборотов);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	МассивСтатейРегл = РезультатЗапроса.ВыгрузитьКолонку("СтатьяРегл");
	СписокСтатейРегл = Новый СписокЗначений();
	СписокСтатейРегл.ЗагрузитьЗначения(МассивСтатейРегл);
	
	Возврат СписокСтатейРегл;
	
КонецФункции
//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-05-22 (#3713)