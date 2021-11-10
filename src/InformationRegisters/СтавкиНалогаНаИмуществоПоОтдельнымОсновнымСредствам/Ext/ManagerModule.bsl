﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

Функция ПолучитьПараметрыФормыВыбораДляКода(НазваниеМакета, ТекущийПериод) Экспорт
	
	КодыЛьгот = Новый ТаблицаЗначений;
	
	КодыЛьгот.Колонки.Добавить("Код");
	КодыЛьгот.Колонки.Добавить("Наименование");
	КодыЛьгот.Колонки.Добавить("КодЕдиницыИзмерения");
	
	Макет	= ПолучитьМакет(НазваниеМакета);
	
	НазваниеОбласти = "";
	СписокОбластей = Новый СписокЗначений;
	ОпределитьПараметрыСпискаКодов(Макет, ТекущийПериод, НазваниеОбласти, СписокОбластей);
	
	ТекущаяОбласть = Макет.Области.Найти("Область" + НазваниеОбласти);
	
	Если НЕ (ТекущаяОбласть = Неопределено) Тогда	
		
		Для НомерСтр = ТекущаяОбласть.Верх По ТекущаяОбласть.Низ Цикл
			
			// Перебираем строки макета.
			КодПоказателя       = СокрП(Макет.Область(НомерСтр, 1).Текст);
			Название            = СокрП(Макет.Область(НомерСтр, 2).Текст);
			КодЕдиницыИзмерения = СокрП(Макет.Область(НомерСтр, 3).Текст);
			
			Если КодПоказателя = "###" Тогда
				Прервать;
			ИначеЕсли ПустаяСтрока(КодПоказателя) Тогда
				Продолжить;
			Иначе
				НоваяСтрока = КодыЛьгот.Добавить();
				НоваяСтрока.Код                 = КодПоказателя;
				НоваяСтрока.Наименование        = Название;
				НоваяСтрока.КодЕдиницыИзмерения = КодЕдиницыИзмерения;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("СписокКодов"           , КодыЛьгот);
	Параметры.Вставить("СписокПериодовДействия", СписокОбластей);
	Параметры.Вставить("ТекущийПериод"         , НазваниеОбласти);
	
	Возврат Параметры;
	
КонецФункции

Процедура ОпределитьПараметрыСпискаКодов(Макет, ТекущийПериод, НазваниеОбласти, СписокОбластей)
	
	Области = Макет.Области;
	Если Области.Количество() = 0 Тогда
		НазваниеОбласти = "";
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекОбласть Из Области Цикл
		СписокОбластей.Добавить(Прав(ТекОбласть.Имя,4));
	КонецЦикла;
	
	ТекущаяОбласть = СписокОбластей[0].Значение;
	Для Каждого ТекОбласть Из СписокОбластей Цикл
		Если Год(ТекущийПериод) < Число(ТекОбласть.Значение) Тогда
			Прервать;
		КонецЕсли;
		
		ТекущаяОбласть = ТекОбласть.Значение;
	КонецЦикла;
	
	НазваниеОбласти = ТекущаяОбласть;
	
КонецПроцедуры

Процедура ЗаполнитьКодВидаИмущества() Экспорт
	
	НаборЗаписей = РегистрыСведений.СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствам.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();
	
	ТребуетсяЗаписатьДанные = Ложь;
	Для каждого СтрокаНабора Из НаборЗаписей Цикл
		
		Если ЗначениеЗаполнено(СтрокаНабора.КодВидаИмущества) Тогда
			Продолжить;
		КонецЕсли;
		
		ТребуетсяЗаписатьДанные = Истина;
		
		СтрокаНабора.КодВидаИмущества = "03";
		
		Если СтрокаНабора.ДоляСтоимостиЧислитель > 0 И СтрокаНабора.ДоляСтоимостиЗнаменатель > 0 Тогда
			СтрокаНабора.КодВидаИмущества = "02";
		КонецЕсли;
		
		Если СтрокаНабора.НалоговаяБаза = Перечисления.НалоговаяБазаПоНалогуНаИмущество.КадастроваяСтоимость Тогда
			СтрокаНабора.КодВидаИмущества = "11";
		ИначеЕсли СтрокаНабора.УдалитьВидИмущества = Перечисления.УдалитьВидыИмущества.ВходитВСоставЕСГС Тогда
			СтрокаНабора.КодВидаИмущества = "01";
		ИначеЕсли СтрокаНабора.УдалитьВидИмущества = Перечисления.УдалитьВидыИмущества.НаходитсяНаТерриторииДругогоГосударства Тогда
			СтрокаНабора.КодВидаИмущества = "04";
		ИначеЕсли СтрокаНабора.УдалитьВидИмущества = Перечисления.УдалитьВидыИмущества.ИспользуетсяВОЭЗКалининградскойОбласти Тогда
			СтрокаНабора.КодВидаИмущества = "05";
		КонецЕсли;
		
		СтрокаНабора.УдалитьВидИмущества = Неопределено;
		
	КонецЦикла;
	
	Если Не ТребуетсяЗаписатьДанные Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
	Исключение
		ШаблонСообщения = НСтр("ru = 'Не выполнено обновление записей регистра сведений ""Ставки налога на имущество по отдельным основным средствам""
                                |%1'");
		
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.РегистрыСведений.СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствам,, 
			ТекстСообщения);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура ЗаполнитьПорядокОпределенияНалоговойБазы() Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда // В подчиненных узлах РИБ не выполняется
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствам.НалоговаяБаза
	|ИЗ
	|	РегистрСведений.СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствам КАК СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствам
	|ГДЕ
	|	СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствам.НалоговаяБаза = ЗНАЧЕНИЕ(Перечисление.НалоговаяБазаПоНалогуНаИмущество.ПустаяСсылка)";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
	
		НаборЗаписей = РегистрыСведений.СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствам.СоздатьНаборЗаписей();
		НаборЗаписей.Прочитать();
		
		Для каждого Запись Из НаборЗаписей Цикл
			
			Если НЕ ЗначениеЗаполнено(Запись.НалоговаяБаза) Тогда
				Запись.НалоговаяБаза = Перечисления.НалоговаяБазаПоНалогуНаИмущество.СреднегодоваяСтоимость;
			КонецЕсли;
			
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьКадастровыйНомер() Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда // В подчиненных узлах РИБ не выполняется
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОсновныеСредства.Ссылка КАК ОсновноеСредство,
	|	ОсновныеСредства.УдалитьКадастровыйНомер КАК КадастровыйНомер,
	|	ОсновныеСредства.УдалитьПомещение КАК Помещение
	|ПОМЕСТИТЬ ТаблицаОС
	|ИЗ
	|	Справочник.ОсновныеСредства КАК ОсновныеСредства
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствам КАК СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствам
	|		ПО ОсновныеСредства.Ссылка = СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствам.ОсновноеСредство
	|ГДЕ
	|	ОсновныеСредства.УдалитьКадастровыйНомер <> """"
	|	И СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствам.Период ЕСТЬ NULL 
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СостоянияОСОрганизаций.ОсновноеСредство КАК ОсновноеСредство,
	|	СостоянияОСОрганизаций.Организация,
	|	СостоянияОСОрганизаций.ДатаСостояния КАК ДатаСостояния,
	|	ТаблицаОС.КадастровыйНомер,
	|	ТаблицаОС.Помещение
	|ПОМЕСТИТЬ СостоянияОС
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияОСОрганизаций КАК СостоянияОСОрганизаций
	|		ПО (СостоянияОСОрганизаций.Активность = ИСТИНА)
	|			И (СостоянияОСОрганизаций.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПринятоКУчету))
	|			И ТаблицаОС.ОсновноеСредство = СостоянияОСОрганизаций.ОсновноеСредство
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство,
	|	ДатаСостояния
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СостоянияОС.ОсновноеСредство КАК ОсновноеСредство,
	|	МАКСИМУМ(СостоянияОС.ДатаСостояния) КАК ДатаСостояния
	|ПОМЕСТИТЬ ДатыПоследнихСостоянийОС
	|ИЗ
	|	СостоянияОС КАК СостоянияОС
	|
	|СГРУППИРОВАТЬ ПО
	|	СостоянияОС.ОсновноеСредство
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство,
	|	ДатаСостояния
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДАТАВРЕМЯ(2014, 1, 1, 0, 0, 0) КАК Период,
	|	СостоянияОС.Организация,
	|	ДатыПоследнихСостоянийОС.ОсновноеСредство КАК ОсновноеСредство,
	|	ЗНАЧЕНИЕ(Перечисление.ПостановкаНаУчетВНалоговомОргане.ПоМестуНахожденияОрганизации) КАК ПостановкаНаУчетВНалоговомОргане,
	|	ЗНАЧЕНИЕ(Перечисление.ПорядокНалогообложенияИмущества.ОсобыеЛьготыНеУстановлены) КАК ПорядокНалогообложения,
	|	ЗНАЧЕНИЕ(Перечисление.НалоговаяБазаПоНалогуНаИмущество.СреднегодоваяСтоимость) КАК НалоговаяБаза,
	|	ВЫБОР
	|		КОГДА НЕ СостоянияОС.Помещение
	|			ТОГДА СостоянияОС.КадастровыйНомер
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК КадастровыйНомер,
	|	ВЫБОР
	|		КОГДА СостоянияОС.Помещение
	|			ТОГДА СостоянияОС.КадастровыйНомер
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК КадастровыйНомерПомещения
	|ИЗ
	|	ДатыПоследнихСостоянийОС КАК ДатыПоследнихСостоянийОС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СостоянияОС КАК СостоянияОС
	|		ПО ДатыПоследнихСостоянийОС.ОсновноеСредство = СостоянияОС.ОсновноеСредство
	|			И ДатыПоследнихСостоянийОС.ДатаСостояния = СостоянияОС.ДатаСостояния";
	
	ТаблицаОС = Запрос.Выполнить().Выгрузить();
	
	НаборЗаписей = РегистрыСведений.СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствам.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();

	Для каждого Запись Из НаборЗаписей Цикл
		
		ОсновноеСредство = Запись.ОсновноеСредство;
		
		Если НЕ ЗначениеЗаполнено(Запись.КадастровыйНомер)
			И НЕ ОсновноеСредство.УдалитьПомещение
			И ЗначениеЗаполнено(ОсновноеСредство.УдалитьКадастровыйНомер) Тогда
				Запись.КадастровыйНомер = ОсновноеСредство.УдалитьКадастровыйНомер;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Запись.КадастровыйНомерПомещения)
			И ОсновноеСредство.УдалитьПомещение
			И ЗначениеЗаполнено(ОсновноеСредство.УдалитьКадастровыйНомер) Тогда
				Запись.КадастровыйНомерПомещения = ОсновноеСредство.УдалитьКадастровыйНомер;
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого СтрокаТаблицы Из ТаблицаОС Цикл
		
		НоваяЗапись = НаборЗаписей.Добавить();
	    ЗаполнитьЗначенияСвойств(НоваяЗапись, СтрокаТаблицы);
		
	КонецЦикла;	
		
	Попытка
		НаборЗаписей.Записать();
	Исключение
		ШаблонСообщения = НСтр("ru = 'Не выполнено обновление записей регистра сведений ""Ставки налога на имущество по отдельным основным средствам""
                                |%1'");
		
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.РегистрыСведений.СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствам,, 
			ТекстСообщения);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецЕсли