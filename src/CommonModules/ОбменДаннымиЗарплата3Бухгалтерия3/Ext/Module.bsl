﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен Зарплата 3 Бухгалтерия 3"
// Серверные процедуры и функции.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет использование обмена данными с БП3.
// Если в параметрах указана организация, то вычисляется использование обмена по этой организации, иначе по всем или любой.
//
// Параметры:
//	Организация - СправочникСсылка.Организации, Неопределено - организация, для которой определяется использование обмена.
//	НастройкиОбмена - Структура, Неопределено - описание см НастройкиОбмена().
//
// Возвращаемое значение:
// 		Булево - Истина если обмен используется, Ложь - в противном случае.
//
Функция ОбменИспользуется(Организация = Неопределено, НастройкиОбмена = Неопределено) Экспорт
	
	Если НастройкиОбмена = Неопределено Тогда
		НастройкиОбмена = НастройкиОбмена();
	КонецЕсли;
	
	Если Организация = Неопределено Тогда
		// Если организация не указана, получаем значение без отбора по организации
		Возврат НастройкиОбмена.ИспользуетсяОбменПоВсемОрганизациям Или НастройкиОбмена.ИспользуетсяОбменПоОрганизациям;
	КонецЕсли;
	
	Возврат НастройкиОбмена.ИспользуетсяОбменПоВсемОрганизациям
		Или НастройкиОбмена.ИспользованиеОбменаПоОрганизациям[Организация];
	
КонецФункции

// См. ОбменДаннымиПереопределяемый.РегистрацияИзмененийНачальнойВыгрузкиДанных
Процедура ОбработкаРегистрацииНачальнойВыгрузкиДанных(Знач Получатель, СтандартнаяОбработка, Отбор) Экспорт
	
	Если ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(Получатель) = "ОбменЗарплата3Бухгалтерия3" Тогда
		РегистрацияИзмененияДляНачальнойВыгрузки(Получатель, СтандартнаяОбработка, Отбор);
	КонецЕсли;
	
КонецПроцедуры
	
#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Устанавливает условное оформление формы списка документов.
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - форма, которая создается.
//
Процедура УстановитьУсловноеОформлениеФормыСписка(Форма) Экспорт
	
	НастройкиОбмена = НастройкиОбмена();
	
	Если НЕ ОбменИспользуется(Неопределено, НастройкиОбмена) Тогда
		Возврат;
	КонецЕсли;
	
	ВыделятьОбработанные = ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.КонфигурацииЗарплатаКадры");
	
	ИспользоватьОбменПоВсемОрганизациям = НастройкиОбмена.ИспользуетсяОбменПоВсемОрганизациям;
	
	Если Не ИспользоватьОбменПоВсемОрганизациям Тогда
		
		ТекстЗапроса = Форма.Список.ТекстЗапроса;
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ЛОЖЬ КАК ИспользуетсяОбмен", "ЕСТЬNULL(ИспользованиеОбменаЗарплата3Бухгалтерия3ПоОрганизациям.Используется, ЛОЖЬ) КАК ИспользуетсяОбмен");
		ТекстЗапроса = ТекстЗапроса + "
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИспользованиеОбменаЗарплата3Бухгалтерия3ПоОрганизациям КАК ИспользованиеОбменаЗарплата3Бухгалтерия3ПоОрганизациям
		|	ПО ДокументОтражениеЗарплатыВБухучете.Организация = ИспользованиеОбменаЗарплата3Бухгалтерия3ПоОрганизациям.Организация";
		Форма.Список.ТекстЗапроса = ТекстЗапроса;
		
	КонецЕсли;
	
	ЭлементОформления = Форма.Список.УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Использование	= Истина;
	
	ГруппаЭлементовОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаЭлементовОтбора.Использование	= Истина;
	
	ЭлементОтбора = ГруппаЭлементовОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование		= Истина;
	ЭлементОтбора.ВидСравнения		= ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("ЗарплатаОтраженаВБухучете");
	ЭлементОтбора.ПравоеЗначение	= ВыделятьОбработанные;
	
	ЭлементОтбора = ГруппаЭлементовОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование		= Истина;
	ЭлементОтбора.ВидСравнения		= ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("Проведен");
	ЭлементОтбора.ПравоеЗначение	= Истина;
	
	Если Не ИспользоватьОбменПоВсемОрганизациям Тогда
		
		ЭлементОтбора = ГруппаЭлементовОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.Использование		= Истина;
		ЭлементОтбора.ВидСравнения		= ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("ИспользуетсяОбмен");
		ЭлементОтбора.ПравоеЗначение	= Истина;
		
	КонецЕсли;
	
	Если ВыделятьОбработанные Тогда
		ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Иначе
		ТекущийШрифт = Форма.Элементы.Список.Шрифт;
		ЖирныйШрифт = Новый Шрифт(ТекущийШрифт, , , Истина);
		ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", ЖирныйШрифт);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НастройкиОбмена()

	УстановитьПривилегированныйРежим(Истина);
	
	ИспользованиеОбмена = Новый Структура;
	ИспользованиеОбмена.Вставить("ИспользуетсяОбменПоВсемОрганизациям", Ложь);
	ИспользованиеОбмена.Вставить("ИспользуетсяОбменПоОрганизациям", Ложь);
	ИспользованиеОбмена.Вставить("ИспользованиеОбменаПоОрганизациям", Новый Соответствие);
	ИспользованиеОбмена.Вставить("ПерсональныеДанныеНеВыгружаются", Ложь);
	
	ИспользованиеОбмена.ИспользуетсяОбменПоВсемОрганизациям = Константы.ИспользоватьОбменЗарплата3Бухгалтерия3ПоВсемОрганизациям.Получить();
	
	ИспользованиеОбменаПоОрганизациям = Новый Соответствие;
	ИспользованиеОбменаПоОрганизациям.Вставить(Справочники.Организации.ПустаяСсылка(), Ложь);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(ИспользованиеОбмена.Используется) КАК ОбменИспользуется
	|ИЗ
	|	РегистрСведений.ИспользованиеОбменаЗарплата3Бухгалтерия3ПоОрганизациям КАК ИспользованиеОбмена
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Организации.Ссылка КАК Организация,
	|	ЕСТЬNULL(ИспользованиеОбмена.Используется, ЛОЖЬ) КАК ОбменИспользуется
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИспользованиеОбменаЗарплата3Бухгалтерия3ПоОрганизациям КАК ИспользованиеОбмена
	|		ПО Организации.Ссылка = ИспользованиеОбмена.Организация";
	
	Результат = Запрос.Выполнить(); 
	Если Не Результат.Пустой() Тогда
		
		ИспользуетсяОбменПоОрганизациям = Результат.Выгрузить().ВыгрузитьКолонку("ОбменИспользуется").Найти(Истина) <> Неопределено;
		ИспользованиеОбмена.ИспользуетсяОбменПоОрганизациям = ИспользуетсяОбменПоОрганизациям;
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ИспользованиеОбменаПоОрганизациям.Вставить(Выборка.Организация, Выборка.ОбменИспользуется);
		КонецЦикла;
		
	КонецЕсли;
	
	ИспользованиеОбмена.ИспользованиеОбменаПоОрганизациям = ИспользованиеОбменаПоОрганизациям;
	
	МДПланОбмена = Метаданные.ПланыОбмена.Найти("ОбменЗарплата3Бухгалтерия3");
	Если МДПланОбмена <> Неопределено Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ЭтотУзел", ПланыОбмена["ОбменЗарплата3Бухгалтерия3"].ЭтотУзел());
		Запрос.Текст =
		"ВЫБРАТЬ
		|	МАКСИМУМ(ОбменЗарплата3Бухгалтерия3.НеВыгружатьПерсональныеДанныеФизическихЛиц) КАК НеВыгружатьПерсональныеДанныеФизическихЛиц
		|ИЗ
		|	#ПолноеИмяПланаОбмена КАК ОбменЗарплата3Бухгалтерия3
		|ГДЕ
		|	ОбменЗарплата3Бухгалтерия3.Ссылка <> &ЭтотУзел";
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ПолноеИмяПланаОбмена", МДПланОбмена.ПолноеИмя());
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ИспользованиеОбмена.ПерсональныеДанныеНеВыгружаются = Выборка.НеВыгружатьПерсональныеДанныеФизическихЛиц;	
		КонецЦикла;	
		
	КонецЕсли;
	
	Возврат ИспользованиеОбмена;

КонецФункции

// Обработчик регистрации изменений для начальной выгрузки данных с отбором по организации.
//
// Параметры:
//
// Получатель - ПланОбменаСсылка - Узел плана обмена, в который требуется выгрузить данные.
//
// СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки
//                                 события.
//  Если в теле процедуры-обработчика установить данному параметру значение Ложь, стандартная обработка события
//  производиться не будет.
//  Отказ от стандартной обработки не отменяет действие.
//  Значение по умолчанию - Истина.
//
Процедура РегистрацияИзмененияДляНачальнойВыгрузки(Получатель, СтандартнаяОбработка, Данные)
	
	СтандартнаяОбработка = Ложь;
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Получатель, "ИспользоватьОтборПоОрганизациям, Организации, ДатаНачалаИспользованияОбмена, НеВыгружатьПерсональныеДанныеФизическихЛиц");
	Организации = ?(ЗначенияРеквизитов.ИспользоватьОтборПоОрганизациям, ЗначенияРеквизитов.Организации.Выгрузить().ВыгрузитьКолонку("Организация"), Неопределено);
	
	ДатаНачалаИспользованияОбмена = ЗначенияРеквизитов.ДатаНачалаИспользованияОбмена;
	ВыгружатьПерсональныеДанныеФизическихЛиц = Не ЗначенияРеквизитов.НеВыгружатьПерсональныеДанныеФизическихЛиц;
	ИспользоватьФильтрПоМетаданным = (ТипЗнч(Данные) = Тип("Массив"));
		
	ОтборПоОрганизациям = (Организации <> Неопределено);
	ОтборПоДате = ЗначениеЗаполнено(ДатаНачалаИспользованияОбмена);
	
	ИмяПланаОбмена = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(Получатель);
	СоставПланаОбмена = Метаданные.ПланыОбмена[ИмяПланаОбмена].Состав;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организации", Организации);
	Запрос.УстановитьПараметр("ПоВсемОрганизациям", Не ОтборПоОрганизациям);
	Запрос.УстановитьПараметр("ДатаНачалаИспользованияОбмена", ДатаНачалаИспользованияОбмена);
	
	Для Каждого ЭлементСоставаПланаОбмена Из СоставПланаОбмена Цикл
		
		ОбъектМетаданных = ЭлементСоставаПланаОбмена.Метаданные;
		ПолноеИмяОбъекта = ОбъектМетаданных.ПолноеИмя();
		
		Если ИспользоватьФильтрПоМетаданным И Данные.Найти(ОбъектМетаданных) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если ОбщегоНазначения.ЭтоСправочник(ОбъектМетаданных) Тогда
			
			Если ОбъектМетаданных = Метаданные.Справочники.Организации Тогда
				
				Запрос.Текст = 
				"ВЫБРАТЬ
				|	Организации.Ссылка
				|ИЗ
				|	Справочник.Организации КАК Организации
				|ГДЕ
				|	(&ПоВсемОрганизациям
				|			ИЛИ Организации.Ссылка В (&Организации))";
				
				Выборка = Запрос.Выполнить().Выбрать();
				Пока Выборка.Следующий() Цикл
					ПланыОбмена.ЗарегистрироватьИзменения(Получатель, Выборка.Ссылка);
				КонецЦикла;
				
			ИначеЕсли ОбъектМетаданных = Метаданные.Справочники.РегистрацииВНалоговомОргане Тогда
				
				Запрос.Текст = 
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ИсторияРегистрацийВНалоговомОргане.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане
				|ПОМЕСТИТЬ ВТРегистрации
				|ИЗ
				|	РегистрСведений.ИсторияРегистрацийВНалоговомОргане КАК ИсторияРегистрацийВНалоговомОргане
				|ГДЕ
				|	(&ПоВсемОрганизациям
				|			ИЛИ ИсторияРегистрацийВНалоговомОргане.РегистрацияВНалоговомОргане.Владелец В (&Организации))
				|	И ИсторияРегистрацийВНалоговомОргане.РегистрацияВНалоговомОргане <> ЗНАЧЕНИЕ(Справочник.РегистрацииВНалоговомОргане.ПустаяСсылка)
				|	И ИсторияРегистрацийВНалоговомОргане.РегистрацияВНалоговомОргане.НаименованиеИФНС <> """"
				|	И ВЫБОР
				|			КОГДА ИсторияРегистрацийВНалоговомОргане.РегистрацияВНалоговомОргане.Владелец.ЮридическоеФизическоеЛицо = ЗНАЧЕНИЕ(Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо)
				|				ТОГДА ИсторияРегистрацийВНалоговомОргане.РегистрацияВНалоговомОргане.КПП <> """"
				|			ИНАЧЕ ИСТИНА
				|		КОНЕЦ
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	РегистрацииВНалоговомОргане.Владелец КАК Владелец,
				|	РегистрацииВНалоговомОргане.Код КАК Код,
				|	РегистрацииВНалоговомОргане.КПП КАК КПП,
				|	РегистрацииВНалоговомОргане.КодПоОКТМО КАК КодПоОКТМО
				|ПОМЕСТИТЬ ВТКоды
				|ИЗ
				|	ВТРегистрации КАК Регистрации
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РегистрацииВНалоговомОргане КАК РегистрацииВНалоговомОргане
				|		ПО Регистрации.РегистрацияВНалоговомОргане = РегистрацииВНалоговомОргане.Ссылка
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	КодыТаблица1.Владелец КАК Владелец,
				|	КодыТаблица1.Код КАК Код,
				|	КодыТаблица1.КПП КАК КПП
				|ИЗ
				|	ВТКоды КАК КодыТаблица1
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТКоды КАК КодыТаблица2
				|		ПО КодыТаблица1.Код = КодыТаблица2.Код
				|			И КодыТаблица1.КПП = КодыТаблица2.КПП
				|			И КодыТаблица1.КодПоОКТМО <> КодыТаблица2.КодПоОКТМО
				|			И КодыТаблица1.Владелец = КодыТаблица2.Владелец
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	ВТРегистрации.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане,
				|	РегистрацииВНалоговомОргане.Владелец КАК Владелец,
				|	РегистрацииВНалоговомОргане.Код КАК Код,
				|	РегистрацииВНалоговомОргане.КПП КАК КПП
				|ИЗ
				|	ВТРегистрации КАК ВТРегистрации
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РегистрацииВНалоговомОргане КАК РегистрацииВНалоговомОргане
				|		ПО ВТРегистрации.РегистрацияВНалоговомОргане = РегистрацииВНалоговомОргане.Ссылка
				|
				|УПОРЯДОЧИТЬ ПО
				|	РегистрацияВНалоговомОргане";
				
				Результат = Запрос.ВыполнитьПакет();
				КоличествоРезультатов = Результат.ВГраница();
				
				РегистрацииДляВыгрузки 	= Результат[КоличествоРезультатов].Выгрузить();
				НеУникальные 			= Результат[КоличествоРезультатов - 1].Выгрузить();
				НеУникальные.Колонки.Добавить("Выгружен", Новый ОписаниеТипов("Булево"));
				
				Отбор = Новый Структура("Владелец,Код,КПП");
				Для каждого СтрокаТЗ Из РегистрацииДляВыгрузки Цикл
				
					ЗаполнитьЗначенияСвойств(Отбор, СтрокаТЗ);
					НайденныеСтроки = НеУникальные.НайтиСтроки(Отбор);
					Если НайденныеСтроки.Количество() > 0 Тогда
						Если НайденныеСтроки[0].Выгружен Тогда
							Продолжить;
						Иначе
							НайденныеСтроки[0].Выгружен = Истина;
						КонецЕсли;
					КонецЕсли;
					
					ПланыОбмена.ЗарегистрироватьИзменения(Получатель, СтрокаТЗ.РегистрацияВНалоговомОргане);
				
				КонецЦикла;
				
			ИначеЕсли ОбъектМетаданных = Метаданные.Справочники.СпособыОтраженияЗарплатыВБухУчете Тогда
				
				Если Не ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.КонфигурацииЗарплатаКадрыРасширенная") Тогда
					ПланыОбмена.ЗарегистрироватьИзменения(Получатель, ОбъектМетаданных);	
				КонецЕсли;
				
			КонецЕсли;
			
		ИначеЕсли ОбщегоНазначения.ЭтоДокумент(ОбъектМетаданных) Тогда	
			
			Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.КонфигурацииЗарплатаКадрыРасширенная") Тогда
				
				Если ВыгружатьПерсональныеДанныеФизическихЛиц Или ОбъектМетаданных = Метаданные.Документы.ОтражениеЗарплатыВБухучете Или ОбъектМетаданных = Метаданные.Документы.НачислениеОценочныхОбязательствПоОтпускам Тогда
					
					Выборка = ВыборкаДокументовПоОрганизациям(ЭлементСоставаПланаОбмена, Организации, ДатаНачалаИспользованияОбмена);
					Пока Выборка.Следующий() Цикл
						ПланыОбмена.ЗарегистрироватьИзменения(Получатель, Выборка.Ссылка);
					КонецЦикла;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ВыборкаДокументовПоОрганизациям(ЭлементСоставаПланаОбмена, Организации, ДатаНачалаИспользованияОбмена)
	
	ПолноеИмяОбъекта = ЭлементСоставаПланаОбмена.Метаданные.ПолноеИмя();
	
	ИмяОтбораПоДате = "";
	Если ЗначениеЗаполнено(ДатаНачалаИспользованияОбмена) Тогда
		
		Если ПолноеИмяОбъекта = "Документ.РегламентированныйОтчет" Тогда
			ИмяОтбораПоДате = "ДатаНачала";
		ИначеЕсли ЭлементСоставаПланаОбмена.Метаданные.Реквизиты.Найти("ПериодРегистрации") <> Неопределено Тогда
			ИмяОтбораПоДате = "ПериодРегистрации";
		ИначеЕсли ЭлементСоставаПланаОбмена.Метаданные.Реквизиты.Найти("ОтчетныйПериод") <> Неопределено
			И Тип(ЭлементСоставаПланаОбмена.Метаданные.Реквизиты.Найти("ОтчетныйПериод").Тип) = Тип("Дата") Тогда
			ИмяОтбораПоДате = "ОтчетныйПериод";
		Иначе
			ИмяОтбораПоДате = "Дата";
		КонецЕсли;
		
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Таблица.Ссылка КАК Ссылка
	|ИЗ
	|	#ПолноеИмяОбъекта КАК Таблица
	|ГДЕ
	|	Таблица.Организация В(&Организации)
	|	И ИСТИНА
	|	И &УсловиеПроведен";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ПолноеИмяОбъекта", ПолноеИмяОбъекта);
	Если Не ПустаяСтрока(ИмяОтбораПоДате) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И Истина", "И Таблица."+ИмяОтбораПоДате+" >= &ДатаНачалаИспользованияОбмена");
	КонецЕсли;
	
	Если Организации = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Таблица.Организация В(&Организации)", "Истина");	
	КонецЕсли;
	
	Если ЭлементСоставаПланаОбмена.Метаданные.Проведение = Метаданные.СвойстваОбъектов.Проведение.Разрешить Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &УсловиеПроведен", "И Таблица.Проведен");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &УсловиеПроведен", "И НЕ Таблица.ПометкаУдаления");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организации", Организации);
	Запрос.УстановитьПараметр("ДатаНачалаИспользованияОбмена", ДатаНачалаИспользованияОбмена);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

#КонецОбласти