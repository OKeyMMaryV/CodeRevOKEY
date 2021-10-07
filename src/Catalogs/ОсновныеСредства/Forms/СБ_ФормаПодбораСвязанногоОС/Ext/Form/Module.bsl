﻿

&НаКлиенте
Процедура Выбрать(Команда)
	ТекСтрока = Элементы.СписокОС.ТекущиеДанные;
	Если ТекСтрока <> Неопределено Тогда
		ОповеститьОВыборе(ТекСтрока.ОсновноеСредство);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПодобратьНаСервере()
	
	Запрос = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ОсновныеСредства.СБ_СвязанноеОС КАК ОсновноеСредство
	|ПОМЕСТИТЬ ВТ_СвязанныеОС
	|ИЗ
	|	Справочник.ОсновныеСредства КАК ОсновныеСредства
	|ГДЕ
	|	ОсновныеСредства.СБ_СвязанноеОС <> ЗНАЧЕНИЕ(Справочник.ОсновныеСредства.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ОсновныеСредства.СБ_СвязанноеОС
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПередачаОСОС.ОсновноеСредство КАК ОсновноеСредство
	|ПОМЕСТИТЬ ВТ_ПереданныеОС
	|ИЗ
	|	Документ.ПередачаОС.ОС КАК ПередачаОСОС
	|ГДЕ
	|	ПередачаОСОС.Ссылка.Организация = &Организация
	|	И ПередачаОСОС.Ссылка.Дата >= &ДатаНач
	|	И ПередачаОСОС.Ссылка.Дата <= &ДатаКон
	|
	|СГРУППИРОВАТЬ ПО
	|	ПередачаОСОС.ОсновноеСредство
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОсновныеСредства.Ссылка КАК ОсновноеСредство
	|ИЗ
	|	Справочник.ОсновныеСредства КАК ОсновныеСредства
	|ГДЕ
	|	ОсновныеСредства.Ссылка В
	|			(ВЫБРАТЬ
	|				ВТ_ПереданныеОС.ОсновноеСредство
	|			ИЗ
	|				ВТ_ПереданныеОС КАК ВТ_ПереданныеОС)
	|	И НЕ ОсновныеСредства.Ссылка В
	|				(ВЫБРАТЬ
	|					ВТ_СвязанныеОС.ОсновноеСредство
	|				ИЗ
	|					ВТ_СвязанныеОС КАК ВТ_СвязанныеОС)";
	Запрос.Текст = ТекстЗапроса; 
	Запрос.УстановитьПараметр("ДатаНач", ПериодОтбора.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаКон", КонецДня(ПериодОтбора.ДатаОкончания));
	Запрос.УстановитьПараметр("Организация", Организация);
	
	СписокОС.Загрузить(Запрос.Выполнить().Выгрузить());	
	
КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)
	ПодобратьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СписокОСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОповеститьОВыборе(Элементы.СписокОС.ТекущиеДанные.ОсновноеСредство);
КонецПроцедуры
