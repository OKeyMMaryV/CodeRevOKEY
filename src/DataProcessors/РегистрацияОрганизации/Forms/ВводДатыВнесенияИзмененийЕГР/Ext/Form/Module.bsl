﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.Заголовок) Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	ДанныеПомощникаЗаполнения = ПолучитьИзВременногоХранилища(Параметры.АдресДанныхПомощника);
	
	Если ТипЗнч(ДанныеПомощникаЗаполнения) = Тип("Структура") И ДанныеПомощникаЗаполнения.Свойство("Изменено") Тогда
		ДанныеПомощникаЗаполнения.Свойство("НаименованиеПолноеНовое", НаименованиеПолное);
		ДанныеПомощникаЗаполнения.Свойство("НаименованиеСокращенноеНовое", НаименованиеСокращенное);
		
		Если ДанныеПомощникаЗаполнения.Изменено.Руководитель Тогда
			Руководитель = Строка(ДанныеПомощникаЗаполнения.ДанныеНовогоРуководителя.Ссылка);
			РуководительДолжность = Строка(ДанныеПомощникаЗаполнения.ДанныеОДолжностиНовогоРуководителя.Должность);
		КонецЕсли;
		
		ДанныеПомощникаЗаполнения.Свойство("ЮридическийАдресНовый", ЮридическийАдрес);
		
		Если ДанныеПомощникаЗаполнения.Свойство("УчредителиНовые")
			И ТипЗнч(ДанныеПомощникаЗаполнения.УчредителиНовые) = Тип("ТаблицаЗначений") Тогда
			Учредители.Загрузить(ДанныеПомощникаЗаполнения.УчредителиНовые);
			ОтобразитьУчредителей();
		КонецЕсли;
		
		Если ДанныеПомощникаЗаполнения.Изменено.ОсновнойВидДеятельности Тогда
			КодОКВЭД = ДанныеПомощникаЗаполнения.КодОКВЭД2Новый;
		ИначеЕсли ДанныеПомощникаЗаполнения.Изменено.ВидыДеятельности Тогда
			КодОКВЭД = ДанныеПомощникаЗаполнения.ДанныеОрганизации.КодОКВЭД2;
		КонецЕсли;
		
		Если ДанныеПомощникаЗаполнения.Свойство("ВидыДеятельностиНовые")
			И ТипЗнч(ДанныеПомощникаЗаполнения.ВидыДеятельностиНовые) = Тип("ТаблицаЗначений") Тогда
			ВидыДеятельности.Загрузить(ДанныеПомощникаЗаполнения.ВидыДеятельностиНовые);
			ОтобразитьВидыДеятельности();
		КонецЕсли;
		
	КонецЕсли;
	
	ДатаИзмененийЕГР = ТекущаяДатаСеанса();
	
	УправлениеФормой();
	
	УстановитьКлючСохраненияПоложенияОкна();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьРеквизиты(Команда)
	Закрыть(ДатаИзмененийЕГР);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеФормой()
	
	Элементы.ГруппаНаименованиеПолное.Видимость = ЗначениеЗаполнено(НаименованиеПолное);
	Элементы.ГруппаНаименованиеСокращенное.Видимость = ЗначениеЗаполнено(НаименованиеСокращенное);
	Элементы.ГруппаРуководитель.Видимость = ЗначениеЗаполнено(Руководитель);
	Элементы.ГруппаРуководительДолжность.Видимость = ЗначениеЗаполнено(РуководительДолжность);
	Элементы.ГруппаЮридическийАдрес.Видимость = ЗначениеЗаполнено(ЮридическийАдрес);
	Элементы.ГруппаКодОКВЭД.Видимость = ЗначениеЗаполнено(КодОКВЭД) Или (ВидыДеятельности.Количество() > 0);
	
	Элементы.СписокУчредителей.Видимость = (Учредители.Количество() > 0);
	Элементы.ВидыДеятельности.Видимость = (ВидыДеятельности.Количество() > 0);
	
	// Спецкостыль для выравнивания элементов.
	МаксимальнаяШиринаЗаголовка = МаксимальнаяШиринаЗаголовка(Элементы);
	Для Каждого ИмяЭлемента Из ИменаЗаголовковЭлементов() Цикл
		Элементы[ИмяЭлемента].Ширина = МаксимальнаяШиринаЗаголовка;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКлючСохраненияПоложенияОкна()
	
	// КлючСохраненияПоложенияОкна составляем из количества видимых групп элементов
	// и количества строк в таблицах "Учредители" и "ВидыДеятельности".
	
	КоличествоВидимыхЭлементов = 0;
	Для Каждого ИмяЭлемента Из ИменаЗаголовковЭлементов() Цикл
		
		Элемент = Элементы[ИмяЭлемента];
		Если Не Элемент.Родитель.Видимость Тогда
			Продолжить;
		КонецЕсли;
		
		КоличествоВидимыхЭлементов = КоличествоВидимыхЭлементов + 1;
		
	КонецЦикла;
	
	КлючСохраненияПоложенияОкна = СтрШаблон("ВидимыеРеквизиты%1Учредители%2Коды%3", Формат(КоличествоВидимыхЭлементов, "ЧГ=0"),
		Формат(Учредители.Количество(), "ЧГ=0"), Формат(ВидыДеятельности.Количество(), "ЧГ=0"));
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция МаксимальнаяШиринаЗаголовка(Элементы)
	
	МаксимальнаяШирина = 0;
	Для Каждого ИмяЭлемента Из ИменаЗаголовковЭлементов() Цикл
		
		Элемент = Элементы[ИмяЭлемента];
		Если Не Элемент.Родитель.Видимость Тогда
			Продолжить;
		КонецЕсли;
		
		Если Элемент.Ширина > МаксимальнаяШирина Тогда
			МаксимальнаяШирина = Элемент.Ширина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МаксимальнаяШирина;
	
КонецФункции

&НаСервереБезКонтекста
Функция ИменаЗаголовковЭлементов()
	
	Заголовки = Новый Массив;
	Заголовки.Добавить("ЗаголовокНаименованиеПолное");
	Заголовки.Добавить("ЗаголовокНаименованиеСокращенное");
	Заголовки.Добавить("ЗаголовокЮридическийАдрес");
	Заголовки.Добавить("ЗаголовокРуководитель");
	Заголовки.Добавить("ЗаголовокРуководительДолжность");
	Заголовки.Добавить("ЗаголовокУчредителя0");
	Заголовки.Добавить("ЗаголовокКодыОКВЭД");
	Заголовки.Добавить("ЗаголовокВидаДеятельности0");
	
	Возврат Заголовки;
	
КонецФункции

&НаСервере
Процедура ОтобразитьУчредителей()
	
	КоличествоПредопределенных = КоличествоПредопределенныхЭлементов("Учредитель");
	КоличествоУчредителей = Учредители.Количество();
	
	// Добавляем недостающие элементы формы.
	Для Индекс = КоличествоПредопределенных По КоличествоУчредителей - 1 Цикл
		ДобавитьПредставлениеУчредителя(Индекс);
	КонецЦикла;
	
	Для Индекс = 0 По КоличествоУчредителей - 1 Цикл
		
		Учредитель = Учредители[Индекс];
		
		ЭлементФормы = Элементы[ИмяЭлементаПоИндексу(Индекс, "Учредитель")];
		ЭлементФормы.Видимость = Истина;
		
		ЭлементФормы = Элементы[ИмяЭлементаПоИндексу(Индекс, "НаименованиеУчредителя")];
		ЭлементФормы.Заголовок = Учредитель.Наименование;
		
		ЭлементФормы = Элементы[ИмяЭлементаПоИндексу(Индекс, "ДоляУчастияУчредителя")];
		ЭлементФормы.Заголовок = ?(Учредитель.ДоляУчастия <> 0, Формат(Учредитель.ДоляУчастия, "ЧН=") + "%", "");
		
		ЭлементФормы = Элементы[ИмяЭлементаПоИндексу(Индекс, "СуммаВзносаУчредителя")];
		ЭлементФормы.Заголовок = ?(Учредитель.СуммаВзноса <> 0, СтрШаблон(НСтр("ru = '%1 руб.'"), Учредитель.СуммаВзноса), "");
		
	КонецЦикла;
	
	Для Индекс = КоличествоУчредителей По КоличествоПредопределенных - 1 Цикл
		ЭлементФормы = Элементы[ИмяЭлементаПоИндексу(Индекс, "Учредитель")];
		ЭлементФормы.Видимость = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПредставлениеУчредителя(Индекс)
	
	ГруппаУчредитель = Элементы.Добавить(
		ИмяЭлементаПоИндексу(Индекс, "Учредитель"),
		Тип("ГруппаФормы"),
		Элементы.УчредителиПредставление);
	ГруппаУчредитель.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаУчредитель.Отображение = ОтображениеОбычнойГруппы.Нет;
	ГруппаУчредитель.Заголовок = СтрШаблон("Учредитель[%1]", Индекс);
	ГруппаУчредитель.ОтображатьЗаголовок = Ложь;
	ГруппаУчредитель.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	ГруппаУчредитель.Объединенная = Ложь;
	
	ЗаголовокУчредителя = Элементы.Добавить(
		ИмяЭлементаПоИндексу(Индекс, "ЗаголовокУчредителя"),
		Тип("ДекорацияФормы"),
		ГруппаУчредитель);
	ЗаголовокУчредителя.Заголовок = НСтр("ru = 'Учредители'");
	ЗаголовокУчредителя.Ширина = Элементы[ИмяЭлементаПоИндексу(0, "ЗаголовокУчредителя")].Ширина;
	ЗаголовокУчредителя.РастягиватьПоГоризонтали = Ложь;
	ЗаголовокУчредителя.ЦветТекста = ЦветаСтиля.ЦветФонаФормы;
	
	Элементы.Добавить(
		ИмяЭлементаПоИндексу(Индекс, "НаименованиеУчредителя"),
		Тип("ДекорацияФормы"),
		ГруппаУчредитель);
	
	ДоляУчастияУчредителя = Элементы.Добавить(
		ИмяЭлементаПоИндексу(Индекс, "ДоляУчастияУчредителя"),
		Тип("ДекорацияФормы"),
		ГруппаУчредитель);
	ДоляУчастияУчредителя.ГоризонтальноеПоложение = Элементы[ИмяЭлементаПоИндексу(0, "ДоляУчастияУчредителя")].ГоризонтальноеПоложение;
	
	СуммаВзносаУчредителя = Элементы.Добавить(
		ИмяЭлементаПоИндексу(Индекс, "СуммаВзносаУчредителя"),
		Тип("ДекорацияФормы"),
		ГруппаУчредитель);
	СуммаВзносаУчредителя.ГоризонтальноеПоложение = Элементы[ИмяЭлементаПоИндексу(0, "СуммаВзносаУчредителя")].ГоризонтальноеПоложение;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьВидыДеятельности()
	
	ТаблицаВидовДеятельности = ВидыДеятельности.Выгрузить();
	
	// Основной код ОКВЭД
	НайденнаяСтрока = ТаблицаВидовДеятельности.Найти(КодОКВЭД, "Код");
	Если НайденнаяСтрока <> Неопределено Тогда
		ТаблицаВидовДеятельности.Удалить(НайденнаяСтрока);
	КонецЕсли;
	
	ЕстьОсновнойКодОКВЭД = Не ПустаяСтрока(КодОКВЭД);
	ЕстьПрочиеКодыОКВЭД = (ТаблицаВидовДеятельности.Количество() > 0);
	
	Если ЕстьОсновнойКодОКВЭД Тогда
		ПредставлениеКодаОКВЭД2 = СтрШаблон(НСтр("ru = '%1 (основной)'"), КодОКВЭД);
		СообщениеОбОшибке = "";
		Если ОрганизацииФормыКлиентСервер.ОКВЭДСоответствуетТребованиям(СообщениеОбОшибке, КодОКВЭД) Тогда
			КодОКВЭД = Новый ФорматированнаяСтрока(ПредставлениеКодаОКВЭД2);
		Иначе
			КодОКВЭД = Новый ФорматированнаяСтрока(
				ПредставлениеКодаОКВЭД2,
				" ",
				Новый ФорматированнаяСтрока(СообщениеОбОшибке, , ЦветаСтиля.ЦветТекстаНекорректногоКонтрагента));
		КонецЕсли;
	ИначеЕсли ЕстьПрочиеКодыОКВЭД Тогда
		СообщениеОбОшибке = НСтр("ru = 'В реестре не указан основной код ОКВЭД'");
		КодОКВЭД = Новый ФорматированнаяСтрока(СообщениеОбОшибке, , ЦветаСтиля.ЦветТекстаНекорректногоКонтрагента);
	Иначе
		СообщениеОбОшибке = НСтр("ru = 'В реестре не указаны коды ОКВЭД'");
		КодОКВЭД = Новый ФорматированнаяСтрока(СообщениеОбОшибке);
	КонецЕсли;
	
	// Выводим сформированную таблицу на форму
	
	КоличествоПредопределенныхСтрок = КоличествоПредопределенныхЭлементов("ВидДеятельности");
	
	ЭлементыСтрокиКодовОКВЭД = Новый Массив;
	МаксКоличествоКодовОКВЭДвСтроке = МаксКоличествоКодовОКВЭДвСтроке(ТаблицаВидовДеятельности.Количество());
	
	ИндексСтроки = 0;
	Для Каждого ВидДеятельности Из ТаблицаВидовДеятельности Цикл
		
		Если ЭлементыСтрокиКодовОКВЭД.Количество() = МаксКоличествоКодовОКВЭДвСтроке Тогда
			
			Если ИндексСтроки = КоличествоПредопределенныхСтрок Тогда
				ДобавитьПредставлениеВидаДеятельности(ИндексСтроки);
				КоличествоПредопределенныхСтрок = КоличествоПредопределенныхСтрок + 1;
			КонецЕсли;
			
			ОтобразитьСтрокуКодовОКВЭД(ИндексСтроки, ЭлементыСтрокиКодовОКВЭД);
			ЭлементыСтрокиКодовОКВЭД.Очистить();
			
			ИндексСтроки = ИндексСтроки + 1;
			
		КонецЕсли;
		
		ЭлементыСтрокиКодовОКВЭД.Добавить(ВидДеятельности.Код);
		
	КонецЦикла;
	
	Если ЭлементыСтрокиКодовОКВЭД.Количество() > 0 Тогда
		
		Если ИндексСтроки = КоличествоПредопределенныхСтрок Тогда
			ДобавитьПредставлениеВидаДеятельности(ИндексСтроки);
			КоличествоПредопределенныхСтрок = КоличествоПредопределенныхСтрок + 1;
		КонецЕсли;
		
		ОтобразитьСтрокуКодовОКВЭД(ИндексСтроки, ЭлементыСтрокиКодовОКВЭД);
		ЭлементыСтрокиКодовОКВЭД.Очистить();
		
		ИндексСтроки = ИндексСтроки + 1;
		
	КонецЕсли;
	
	КоличествоСтрокВидовДеятельности = ИндексСтроки;
	
	Для Индекс = КоличествоСтрокВидовДеятельности По КоличествоПредопределенныхСтрок - 1 Цикл
		ЭлементФормы = Элементы[ИмяЭлементаПоИндексу(Индекс, "ВидДеятельности")];
		ЭлементФормы.Видимость = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьСтрокуКодовОКВЭД(Индекс, ЭлементыСтрокиКодовОКВЭД)
	
	ЭлементФормы = Элементы[ИмяЭлементаПоИндексу(Индекс, "ВидДеятельности")];
	ЭлементФормы.Видимость = Истина;
	
	ЭлементФормы = Элементы[ИмяЭлементаПоИндексу(Индекс, "СтрокаКодовОКВЭД")];
	ЭлементФормы.Заголовок = СтрСоединить(ЭлементыСтрокиКодовОКВЭД, "; ");
	
КонецПроцедуры

// Добавляет новую строку кодов ОКВЭД на форму
//
&НаСервере
Процедура ДобавитьПредставлениеВидаДеятельности(Индекс)
	
	ГруппаВидДеятельности = Элементы.Добавить(
		ИмяЭлементаПоИндексу(Индекс, "ВидДеятельности"),
		Тип("ГруппаФормы"),
		Элементы.ВидыДеятельности);
	ГруппаВидДеятельности.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаВидДеятельности.Отображение = ОтображениеОбычнойГруппы.Нет;
	ГруппаВидДеятельности.Заголовок = СтрШаблон("ВидДеятельности[%1]", Индекс);
	ГруппаВидДеятельности.ОтображатьЗаголовок = Ложь;
	ГруппаВидДеятельности.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	ГруппаВидДеятельности.Объединенная = Ложь;
	
	ЗаголовокВидаДеятельности = Элементы.Добавить(
		ИмяЭлементаПоИндексу(Индекс, "ЗаголовокВидаДеятельности"),
		Тип("ДекорацияФормы"),
		ГруппаВидДеятельности);
	ЗаголовокВидаДеятельности.Заголовок = НСтр("ru = 'КодыОКВЭД'");
	ЗаголовокВидаДеятельности.Ширина = Элементы[ИмяЭлементаПоИндексу(0, "ЗаголовокВидаДеятельности")].Ширина;
	ЗаголовокВидаДеятельности.РастягиватьПоГоризонтали = Ложь;
	ЗаголовокВидаДеятельности.ЦветТекста = ЦветаСтиля.ЦветФонаФормы;
	
	СтрокаКодовОКВЭД = Элементы.Добавить(
		ИмяЭлементаПоИндексу(Индекс, "СтрокаКодовОКВЭД"),
		Тип("ДекорацияФормы"),
		ГруппаВидДеятельности);
	СтрокаКодовОКВЭД.АвтоМаксимальнаяШирина = Ложь;
	
КонецПроцедуры

// Возвращает число кодов ОКВЭД в строке формы
//
&НаСервереБезКонтекста
Функция МаксКоличествоКодовОКВЭДвСтроке(КоличествоВидовДеятельности)
	
	ПредопределенноеЗначение = 10;
	Если КоличествоВидовДеятельности < ПредопределенноеЗначение Тогда
		Возврат ПредопределенноеЗначение; // Не имеет значения
	КонецЕсли;
	
	КоличествоВПоследнейСтроке = КоличествоВидовДеятельности
		- (ПредопределенноеЗначение * Цел(КоличествоВидовДеятельности / ПредопределенноеЗначение));
	Если КоличествоВПоследнейСтроке = 1 Тогда
		Возврат ПредопределенноеЗначение + 1; // Избегаем переноса ради одного кода
	Иначе
		Возврат ПредопределенноеЗначение;
	КонецЕсли;
	
КонецФункции

// Возвращает число элементов на форме с именем ПрефиксИмени1, ПрефиксИмени2 и т.д.
//
&НаСервере
Функция КоличествоПредопределенныхЭлементов(ПрефиксИмени)
	
	Количество = 0;
	Пока Истина Цикл
		Если Элементы.Найти(ИмяЭлементаПоИндексу(Количество, ПрефиксИмени)) <> Неопределено Тогда
			Количество = Количество + 1;
		Иначе
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Количество;
	
КонецФункции

// Возвращает имя элемента формы
//
&НаСервереБезКонтекста
Функция ИмяЭлементаПоИндексу(Индекс, ПрефиксИмени)
	
	Возврат СтрШаблон(ПрефиксИмени + "%1", Формат(Индекс, "ЧН=0; ЧГ=0"));
	
КонецФункции

#КонецОбласти
