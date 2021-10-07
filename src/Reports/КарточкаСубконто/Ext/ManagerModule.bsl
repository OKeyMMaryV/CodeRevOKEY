﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует набор параметров, задающих флаги выполнения дополнительных действий над сущностями, обрабатываемыми
// в процессе формирования отчета.
//
// Возвращаемое значение:
//   Структура   - флаги, задающие необходимость дополнительных действий.
//
Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);
	Результат.Вставить("ПроверкаИтогов",                     Истина);

	Возврат Результат;
	
КонецФункции

// Формирует текст, выводимый в заголовке отчета.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//
// Возвращаемое значение:
//   Строка      - текст заголовка с учетом периода.
//
Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	ТекстСубконто = "";
	Для Каждого ВидСубконто Из ПараметрыОтчета.СписокВидовСубконто Цикл
		ТекстСубконто = ТекстСубконто + ВидСубконто + ", ";
	КонецЦикла;
	Если Не ПустаяСтрока(ТекстСубконто) Тогда
		ТекстСубконто = Лев(ТекстСубконто, СтрДлина(ТекстСубконто) - 2);
	КонецЕсли;
	
	Возврат СтрШаблон(
		НСтр("ru = 'Карточка субконто %1%2'"),
		ТекстСубконто,
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода));
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет. Изменения сохранены не будут.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Схема        - СхемаКомпоновкиДанных - описание получаемых данных.
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - связь настроек компоновки данных и схемы компоновки.
//
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	БухгалтерскиеОтчеты.ИзменитьСхемуДляОтборовПоДопСвойствамСубконто(ПараметрыОтчета, Схема, КомпоновщикНастроек);
	
	МассивВидовСубконто = Новый Массив;
	Для Каждого ЭлементСписка Из ПараметрыОтчета.СписокВидовСубконто Цикл
		Если ЗначениеЗаполнено(ЭлементСписка.Значение) Тогда 
			МассивВидовСубконто.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивВидовСубконто.Количество() > 0 Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СписокВидовСубконто", МассивВидовСубконто);
	КонецЕсли;
	
	ЗначениеПараметра = ?(ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода),
		НачалоДня(ПараметрыОтчета.НачалоПериода), Дата(1, 1, 1));
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", ЗначениеПараметра);
	ЗначениеПараметра = ?(ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода),
		КонецДня(ПараметрыОтчета.КонецПериода), Дата(3999, 12, 31));
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", ЗначениеПараметра);
	
	ИзменитьСхемуДляПоказателяКонтроль(ПараметрыОтчета, Схема, КомпоновщикНастроек);
		
	Если ПараметрыОтчета.Периодичность = 0 Тогда
		
		КомпоновщикНастроек.Настройки.Структура[0].Использование = Ложь;

		НастраиваемаяСтруктура = КомпоновщикНастроек.Настройки.Структура[1];
		НастраиваемаяСтруктура.Использование = Истина;
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(
			НастраиваемаяСтруктура.Структура[0].Отбор, "Регистратор", , ВидСравненияКомпоновкиДанных.Заполнено);
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(
			НастраиваемаяСтруктура.Структура[0], "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
		
	Иначе
		
		НастраиваемаяСтруктура = КомпоновщикНастроек.Настройки.Структура[0];
		НастраиваемаяСтруктура.Использование = Истина;
		НастраиваемаяСтруктура = НастраиваемаяСтруктура.Структура[0];
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(
			НастраиваемаяСтруктура.Отбор, "ПериодГруппировки", , ВидСравненияКомпоновкиДанных.Заполнено);
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(
			НастраиваемаяСтруктура.Структура[0].Отбор, "Регистратор", , ВидСравненияКомпоновкиДанных.Заполнено);
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(
			НастраиваемаяСтруктура, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(
			НастраиваемаяСтруктура.Структура[0], "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
		
		КомпоновщикНастроек.Настройки.Структура[1].Использование = Ложь;
		
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", ПараметрыОтчета.Периодичность);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПС", Символы.ПС);
		
	ЛинияСплошная = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	
	МассивМакетов = Новый Массив;
	МассивМакетов.Добавить("ПериодГруппировкиЗаголовок"); 
	МассивМакетов.Добавить("ОбщиеИтогиЗаголовок");
	МассивМакетов.Добавить("ОбщиеИтогиПодвал");
	МассивМакетов.Добавить("ПроводкиЗаголовок");
		
	Для Каждого ЭлементМакет Из МассивМакетов Цикл
		
		ОписаниеМакета = Схема.Макеты[ЭлементМакет + "Образец"].Макет;
		Схема.Макеты[ЭлементМакет].Макет = БухгалтерскиеОтчетыВызовСервера.ПолучитьКопиюОписанияМакета(ОписаниеМакета);
		ОписаниеМакета = Схема.Макеты[ЭлементМакет].Макет;
		
		МассивСтрокДляУдаления = Новый Массив;
		Индекс = 0;
		Для Каждого ЭлементМассива Из ПараметрыОтчета.НаборПоказателей Цикл
			Если Не ПараметрыОтчета["Показатель" + ЭлементМассива]
			 Или Не БухгалтерскиеОтчетыКлиентСервер.ПоказательДоступен(
					КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора, ЭлементМассива + "ОборотДт") Тогда 
				МассивСтрокДляУдаления.Добавить(ОписаниеМакета[Индекс]);
			КонецЕсли;
			Индекс = Индекс + 1;
		КонецЦикла;	
		
		Для Каждого Строка Из МассивСтрокДляУдаления Цикл
			ОписаниеМакета.Удалить(Строка);
		КонецЦикла;
		
		Если Не ПараметрыОтчета.ПоказательВалютнаяСумма Тогда
			Параметры = Схема.Макеты[ЭлементМакет].Параметры;
			
			ПараметрыДляУдаления = Новый Массив;
			Для Каждого Параметр Из Параметры Цикл
				Если СтрНайти(Параметр.Имя, "валют") > 0 Тогда
					ПараметрыДляУдаления.Добавить(Параметр);
				КонецЕсли;
			КонецЦикла;
			Для Каждого Параметр Из ПараметрыДляУдаления Цикл
				Параметры.Удалить(Параметр);
			КонецЦикла;
		КонецЕсли;
				
		КоличествоСтрок = ОписаниеМакета.Количество();
		
		// Обвести область.
		Если КоличествоСтрок > 0 Тогда
			Для Индекс = 0 По 12 Цикл
				ПоследняяСтрока = ?(ЭлементМакет = "ОбщиеИтогиПодвал" И Индекс < 4, 0, КоличествоСтрок - 1);
				ПараметрГраницы = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПараметр(ОписаниеМакета[0].Ячейки[Индекс].Оформление.Элементы, "СтильГраницы");
				
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
					ПараметрГраницы.ЗначенияВложенныхПараметров,
					"СтильГраницы.Сверху",
					ЛинияСплошная);
					
				ПараметрГраницы = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПараметр(ОписаниеМакета[ПоследняяСтрока].Ячейки[Индекс].Оформление.Элементы, "СтильГраницы");
				
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
					ПараметрГраницы.ЗначенияВложенныхПараметров,
					"СтильГраницы.Снизу",
					ЛинияСплошная);
					
			КонецЦикла;
		КонецЕсли;
		
		Для Индекс = 1 По КоличествоСтрок - 1 Цикл
			ОписаниеМакета[Индекс].Ячейки[0].Элементы.Очистить();
			
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
				ОписаниеМакета[Индекс].Ячейки[0].Оформление.Элементы,
				"ОбъединятьПоВертикали",
				Истина);
			
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
				ОписаниеМакета[Индекс].Ячейки[0].Оформление.Элементы,
				"Расшифровка",
				Неопределено,
				Ложь);
			
			ОписаниеМакета[Индекс].Ячейки[1].Элементы.Очистить();
			
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
				ОписаниеМакета[Индекс].Ячейки[1].Оформление.Элементы,
				"ОбъединятьПоВертикали",
				Истина);
			
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
				ОписаниеМакета[Индекс].Ячейки[1].Оформление.Элементы,
				"Расшифровка",
				Неопределено,
				Ложь);
			
			ОписаниеМакета[Индекс].Ячейки[2].Элементы.Очистить();
			
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
				ОписаниеМакета[Индекс].Ячейки[2].Оформление.Элементы,
				"ОбъединятьПоВертикали",
				Истина);
				
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
				ОписаниеМакета[Индекс].Ячейки[2].Оформление.Элементы,
				"Расшифровка",
				Неопределено,
				Ложь);
			
			ОписаниеМакета[Индекс].Ячейки[3].Элементы.Очистить();
			
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
				ОписаниеМакета[Индекс].Ячейки[3].Оформление.Элементы,
				"ОбъединятьПоВертикали",
				Истина);
				
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
				ОписаниеМакета[Индекс].Ячейки[3].Оформление.Элементы,
				"Расшифровка",
				Неопределено,
				Ложь);
			
			Если ЭлементМакет = "ПроводкиЗаголовок" Тогда
				ОписаниеМакета[Индекс].Ячейки[5].Элементы.Очистить();
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
					ОписаниеМакета[Индекс].Ячейки[5].Оформление.Элементы,
					"ОбъединятьПоВертикали",
					Истина);
					
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
					ОписаниеМакета[Индекс].Ячейки[5].Оформление.Элементы,
					"Расшифровка",
					Неопределено,
					Ложь);
					
				ОписаниеМакета[Индекс].Ячейки[8].Элементы.Очистить();
				
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
					ОписаниеМакета[Индекс].Ячейки[8].Оформление.Элементы,
					"ОбъединятьПоВертикали",
					Истина);
					
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
					ОписаниеМакета[Индекс].Ячейки[8].Оформление.Элементы,
					"Расшифровка",
					Неопределено,
					Ложь);
				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Если Не ПараметрыОтчета.ПоказательБУ Тогда
		ГруппаОтборов = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтборов.Использование = Истина;
		ГруппаОтборов.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		Для Каждого ЭлементМассива Из ПараметрыОтчета.НаборПоказателей Цикл
			Если ЭлементМассива <> "БУ" И ПараметрыОтчета["Показатель" + ЭлементМассива] Тогда
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(
					ГруппаОтборов,
					ЭлементМассива + "ОборотДт",
					0,
					ВидСравненияКомпоновкиДанных.НеРавно);
					
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(
					ГруппаОтборов,
					ЭлементМассива + "ОборотКт",
					0,
					ВидСравненияКомпоновкиДанных.НеРавно);
				
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

// В процедуре можно уточнить особенности вывода данных в отчет.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  МакетКомпоновки - МакетКомпоновкиДанных - описание выводимых данных.
//
Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	// Если показатель один, то удалим колонку "Показатель".
	Если КоличествоПоказателей = 1 Тогда
		Для Каждого Макет Из МакетКомпоновки.Макеты Цикл
			Для Каждого СтрокаМакета Из Макет.Макет Цикл
				Если СтрокаМакета.Ячейки.Количество() > 4 Тогда // удаляем только из неслужебных строк
					СтрокаМакета.Ячейки.Удалить(СтрокаМакета.Ячейки[4]);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Процедура проверяет контрольное соотношение "начальные остатки + обороты Дт - обороты Кт = конечные остатки".
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Результат    - ТабличныйДокумент - содержит результат формирования отчета.
//
Процедура ПроверитьКорректностьИтогов(ПараметрыОтчета, Результат) Экспорт

	ДополнительныеСвойства = ПараметрыОтчета.НастройкиКомпоновкиДанных.ДополнительныеСвойства;
	ДополнительныеСвойства.Вставить("КонтрольноеСоотношениеИтоговВыполняется", Истина);
	
	ОбластьИтогов = БухгалтерскиеОтчеты.ОбластьЧтенияИтогов(ПараметрыОтчета);
	Если ОбластьИтогов.РазделительДробнойЧасти = Неопределено // нет однозначного представления сумм в ячейках
	 Или ОбластьИтогов.НомерСтрокиПоказателяКонтрольОтносительный = 0 // единственный показатель - это "Контроль"
		Тогда
		
		Возврат;
		
	КонецЕсли;
	
	КонтрольноеСоотношение = 0;
	
	// Определяем позиции колонок с суммами из шапки.
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	ПоследняяИзЯчеекИтогов = Результат.ШиринаТаблицы;

	ФлагиОбщегоИтога = ОбластьИтогов.ФлагиОбщегоИтога;
	ФлагиОбщегоИтога.Вставить(ПоследняяИзЯчеекИтогов, -1); // сальдо начальное
	ОбластьИтогов.ИскатьФлагУчета = Истина;

	ОбластьИтогов.ПерваяИзСтрокИтогов = 1;
	Если ПараметрыОтчета.ВыводитьЗаголовок Тогда
		ОбластьЗаголовок = Результат.Области.Найти("Заголовок");
		Если ОбластьЗаголовок <> Неопределено Тогда
			ОбластьИтогов.ПерваяИзСтрокИтогов = ОбластьЗаголовок.Низ + 1;
		КонецЕсли;
	КонецЕсли;
	ОбластьИтогов.ПерваяИзСтрокИтогов = ОбластьИтогов.ПерваяИзСтрокИтогов + 2;
	ОбластьИтогов.ПоследняяИзСтрокИтогов = ОбластьИтогов.ПерваяИзСтрокИтогов + КоличествоПоказателей - 1;
	Если ПараметрыОтчета.ПоказательКонтроль Тогда
		ОбластьИтогов.НомерСтрокиПоказателяКонтрольАбсолютный = ОбластьИтогов.ПерваяИзСтрокИтогов
			+ ОбластьИтогов.НомерСтрокиПоказателяКонтрольОтносительный - 1;
	КонецЕсли;
	БухгалтерскиеОтчеты.ДополнитьКонтрольноеСоотношение(Результат, ОбластьИтогов, КонтрольноеСоотношение);

	ФлагиОбщегоИтога.Очистить();
	ФлагиОбщегоИтога.Вставить(ПоследняяИзЯчеекИтогов - 7, -1); // оборот Дебет
	ФлагиОбщегоИтога.Вставить(ПоследняяИзЯчеекИтогов - 4, 1);  // оборот Кредит
	ОбластьИтогов.ИскатьФлагУчета = Ложь;

	ОбластьИтогов.ПоследняяИзСтрокИтогов = Результат.ВысотаТаблицы;
	ОбластьИтогов.ПерваяИзСтрокИтогов = ОбластьИтогов.ПоследняяИзСтрокИтогов - КоличествоПоказателей + 1;
	Если ПараметрыОтчета.ПоказательКонтроль Тогда
		ОбластьИтогов.НомерСтрокиПоказателяКонтрольАбсолютный = ОбластьИтогов.ПерваяИзСтрокИтогов
			+ ОбластьИтогов.НомерСтрокиПоказателяКонтрольОтносительный - 1;
	КонецЕсли;
	БухгалтерскиеОтчеты.ДополнитьКонтрольноеСоотношение(Результат, ОбластьИтогов, КонтрольноеСоотношение);
	
	ФлагиОбщегоИтога.Очистить();
	ФлагиОбщегоИтога.Вставить(ПоследняяИзЯчеекИтогов, 1);  // сальдо конечное
	ОбластьИтогов.ИскатьФлагУчета = Истина;
	
	БухгалтерскиеОтчеты.ДополнитьКонтрольноеСоотношение(Результат, ОбластьИтогов, КонтрольноеСоотношение);

	Если КонтрольноеСоотношение <> 0 Тогда
		
		ОтборыОтчета = ПараметрыОтчета.НастройкиКомпоновкиДанных.Отбор.Элементы;
		Если БухгалтерскиеОтчеты.ИспользуютсяОборотныеСубконто(ПараметрыОтчета.СписокВидовСубконто, ОтборыОтчета)
		 Или БухгалтерскиеОтчеты.ИспользуетсяОтборПоРегистратору(ОтборыОтчета) Тогда
			// Настройки отбора допускают вывод оборотов без вывода остатков.
			Возврат;
		КонецЕсли;

	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("КонтрольноеСоотношениеИтоговВыполняется", КонтрольноеСоотношение = 0);
	
КонецПроцедуры

// В процедуре можно изменить табличный документ после вывода в него данных.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Результат    - ТабличныйДокумент - сформированный отчет.
//
Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);

	Если Результат.Области.Найти("Заголовок") = Неопределено Тогда
		Результат.ФиксацияСверху = 2;
	Иначе
		Результат.ФиксацияСверху = Результат.Области.Заголовок.Низ + 2;
	КонецЕсли;
	
КонецПроцедуры

// Задает набор показателей, которые позволяет анализировать отчет.
//
// Возвращаемое значение:
//   Массив      - основные суммовые показатели отчета.
//
Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	НаборПоказателей.Добавить("НУ");
	НаборПоказателей.Добавить("ПР");
	НаборПоказателей.Добавить("ВР");
	НаборПоказателей.Добавить("Контроль");
	НаборПоказателей.Добавить("ВалютнаяСумма");
	НаборПоказателей.Добавить("Количество");
	
	Возврат НаборПоказателей;
	
КонецФункции

// Задает набор опций, которые позволяет настраивать отчет.
//
// Возвращаемое значение:
//   Массив      - имена опций.
//
Функция СохраняемыеОпции() Экспорт
	
	КоллекцияНастроек = Новый Массив;
	Для каждого Показатель Из ПолучитьНаборПоказателей() Цикл
		КоллекцияНастроек.Добавить("Показатель" + Показатель);
	КонецЦикла;
	КоллекцияНастроек.Добавить("СписокВидовСубконто");
	КоллекцияНастроек.Добавить("Периодичность");
	
	Возврат КоллекцияНастроек;
	
КонецФункции

#КонецОбласти

#Область РасшифровкаСтандартныхОтчетов

// Заполняет настройки расшифровки (см. БухгалтерскиеОтчетыКлиентСервер.НовыйУниверсальныеНастройки) для переданного экземпляра отчета.
//
// Параметры:
//  Настройки				 - Структура								 - Настройки расшифровки отчета, которые нужно заполнить (см. БухгалтерскиеОтчетыКлиентСервер.НовыйУниверсальныеНастройки).
//  Объект					 - ОтчетОбъект								 - Отчет из данных которого нудно собрать универсальные настройки.
//  ДанныеРасшифровки		 - ДанныеРасшифровкиКомпоновкиДанных		 - Данные расшифровки отчета.
//  ИдентификаторРасшифровки - ИдентификаторРасшифровкиКомпоновкиДанных  - Идентификатор расшифровки из ячейки для которой вызвана расшифровка.
//  РеквизитыРасшифровки	 - Структура								 - Реквизиты отчета полученные из контекста расшифровываемой ячейки.
//
Процедура ЗаполнитьНастройкиРасшифровки(Настройки, Объект, ДанныеРасшифровки, ИдентификаторРасшифровки, РеквизитыРасшифровки) Экспорт

	БухгалтерскиеОтчетыРасшифровка.ЗаполнитьНастройкиРасшифровкиПоДаннымСтандартногоОтчета(
		Настройки,
		ДанныеРасшифровки,
		ИдентификаторРасшифровки,
		Объект,
		РеквизитыРасшифровки);
	
КонецПроцедуры

// Адаптирует переданные настройки для данного вида отчетов.
// Перед применением настроек расшифровки может возникнуть необходимость учесть особенности этого вида отчетов.
//
// Параметры:
//  Настройки	 - Структура - Настройки которые нужно адаптировать (см. БухгалтерскиеОтчетыКлиентСервер.НовыйУниверсальныеНастройки).
//
Процедура АдаптироватьНастройки(Настройки) Экспорт

	// Удалим автоотступ из условного оформления.
	БухгалтерскиеОтчеты.УдалитьАвтоотступИзУсловногоОформления(Настройки.УсловноеОформление);
	
КонецПроцедуры

// Устанавливает какими отчетами и при каких условиях может быть расшифрован этот вид отчетов.
//
// Параметры:
//  Правила - ТаблицаЗначений с правилами расшифровки этого отчета см. БухгалтерскиеОтчетыРасшифровка.НовыйПравилаРасшифровки.
//
Процедура ЗаполнитьПравилаРасшифровки(Правила) Экспорт

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Дополняет текст наборов данных ОстаткиНаКонец и ОстаткиНаНачало подзапросом, удаляющим суммы Контроль по счетам,
// где налоговый учет не ведется. 
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Схема        - СхемаКомпоновкиДанных - описание получаемых данных.
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - связь настроек компоновки данных и схемы компоновки.
//
Процедура ИзменитьСхемуДляПоказателяКонтроль(ПараметрыОтчета, Схема, КомпоновщикНастроек)
	
	Если Не ПараметрыОтчета.ПоказательКонтроль Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрВидыСубконто = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "СписокВидовСубконто");
	
	// Проверяем наличие субсчетов, на одних из которых включен налоговый учет, а на других отключен.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидыСубконто", ПараметрВидыСубконто.Значение);
	Если ЗначениеЗаполнено(ПараметрВидыСубконто.Значение) Тогда
		Запрос.УстановитьПараметр("КоличествоСубконто", ПараметрВидыСубконто.Значение.Количество()); 
	Иначе
		Запрос.УстановитьПараметр("КоличествоСубконто", 0); 
	КонецЕсли;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ХозрасчетныйВидыСубконто.Ссылка КАК Счет
	|ПОМЕСТИТЬ Субсчета
	|ИЗ
	|	ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто
	|ГДЕ
	|	ХозрасчетныйВидыСубконто.ВидСубконто В(&ВидыСубконто)
	|
	|СГРУППИРОВАТЬ ПО
	|	ХозрасчетныйВидыСубконто.Ссылка
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(*) = &КоличествоСубконто
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Счет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(Хозрасчетный.НалоговыйУчет) КАК СуществуетНУ,
	|	МИНИМУМ(Хозрасчетный.НалоговыйУчет) КАК ЛюбойНУ
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка В
	|			(ВЫБРАТЬ
	|				Субсчета.Счет КАК Счет
	|			ИЗ
	|				Субсчета КАК Субсчета)";
	
	Проверка = Запрос.Выполнить().Выбрать();
	Если Проверка.Следующий()
	   И Проверка.СуществуетНУ = Проверка.ЛюбойНУ Тогда // на всех счетах признак НУ одинаковый
		Возврат;
	КонецЕсли;

	// Запросы общих остатков получают остаток как по счетам, поддерживающим налоговый учет (контроль нужен),
	// так и по счетам, не поддерживающим налоговый учет (контроль должен давать 0).
	// Чтобы оставить только общие остатки по счетам с НУ, мы добавляем второй подзапрос, который получает сторнирующие
	// суммы для основного запроса.
	// Однако выделять остаток по счетам с НУ для каждой проводки нерационально. Суммы контроля в остатках детально по
	// проводкам не вычисляются.
	
	Если Не КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("ИзмененТекстЗапросаСКД") Тогда
		Схема = ПолучитьМакет("СхемаКомпоновкиДанных");
	КонецЕсли;
	
	ОписаниеЗапроса = Новый СхемаЗапроса;
	ОписаниеЗапроса.УстановитьТекстЗапроса(Схема.НаборыДанных.Проводки.Запрос);
	
	Для каждого ЗапросПакета Из ОписаниеЗапроса.ПакетЗапросов Цикл
	
		Если ЗапросПакета.ТаблицаДляПомещения <> "ОстаткиНаНачало"
		   И ЗапросПакета.ТаблицаДляПомещения <> "ОстаткиНаКонец" Тогда
			Продолжить;
		КонецЕсли;
		
		БухгалтерскиеОтчеты.ДобавитьСторноДляПоказателяКонтроль(ПараметрыОтчета, ЗапросПакета);
	
	КонецЦикла;
	
	Схема.НаборыДанных.Проводки.Запрос = ОписаниеЗапроса.ПолучитьТекстЗапроса();
	КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ИзмененТекстЗапросаСКД", Истина);
											
КонецПроцедуры

#КонецОбласти

#КонецЕсли