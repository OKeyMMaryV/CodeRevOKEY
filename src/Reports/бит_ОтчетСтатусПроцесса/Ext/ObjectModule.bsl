#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Процедура формирования отчета. 
// 
// Параметры:
//  ТД - ТабличныйДокумент - табличный документ, в который выводится отчет.
//
Процедура ВывестиОтчет(ТД) Экспорт

	ТД.Очистить();
	
 	Макет = Отчеты.бит_ОтчетСтатусПроцесса.ПолучитьМакет("Макет");
	
	ОблЗаголовок       = Макет.ПолучитьОбласть("Заголовок");
	ОблПустаяСтрока    = Макет.ПолучитьОбласть("ПустаяСтрока");
	ОблСтрокаПараметры = Макет.ПолучитьОбласть("СтрокаПараметры");
	ОблСтрокаГруппа    = Макет.ПолучитьОбласть("СтрокаГруппа");
	ОблСтрока          = Макет.ПолучитьОбласть("Строка");

	ТД.Вывести(ОблЗаголовок);
	ТД.Вывести(ОблПустаяСтрока);
	
	// Реквизиты отчета
	Исключения = Новый Массив;
	Для каждого МетаРекв Из Метаданные.Отчеты.бит_ОтчетСтатусПроцесса.Реквизиты Цикл
		
		Если НЕ Исключения.Найти(МетаРекв.Имя) = Неопределено Тогда
		
		  Продолжить;	
		
		КонецЕсли; 
		
		ОблСтрокаПараметры.Параметры.ИмяПараметра = МетаРекв.Синоним;
		
		Если МетаРекв.Имя = "Процесс" Тогда
			
			ТекЗначение = ЭтотОбъект[МетаРекв.Имя];
			Если НЕ ЗначениеЗаполнено(ТекЗначение) Тогда
			
				ТекЗначение =  НСтр("ru = 'Задачи вне процесса'");
			
			КонецЕсли; 
			
		Иначе
			
			ТекЗначение = ЭтотОбъект[МетаРекв.Имя];
		
		КонецЕсли; 
		ОблСтрокаПараметры.Параметры.ЗначениеПараметра = ТекЗначение;
		
		ТД.Вывести(ОблСтрокаПараметры);
	
	КонецЦикла; 
	
	ТД.Вывести(ОблПустаяСтрока);	
	
	// Получаем дерево с данными
	ДеревоДанных = СформироватьДеревоДанных();
	
	// Вывод дерева
	ТД.НачатьАвтогруппировкуСтрок();
	ВывестиДерево(ТД, ОблСтрокаГруппа, ОблСтрока, ДеревоДанных);
	ТД.ЗакончитьАвтогруппировкуСтрок();
	ТД.Вывести(ОблПустаяСтрока);
	
КонецПроцедуры // ВывестиОтчет()

// Формирует дерево с данными к выводу в отчет. 
// 
// Возвращаемое значение:
//  ДеревоЗначений - дерево данных.
//
Функция СформироватьДеревоДанных() Экспорт

	// Инициализация дерева
	ДеревоДанных = Новый ДеревоЗначений;
	ДеревоДанных.Колонки.Добавить("Имя");
	ДеревоДанных.Колонки.Добавить("Значение");
	ДеревоДанных.Колонки.Добавить("ЭтоГруппа");
	
	// Получение характеристик процесса
    Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущаяДата", ЭтотОбъект.ДатаФормирования);
	Запрос.УстановитьПараметр("Процесс", ЭтотОбъект.Процесс);
	Запрос.Текст = "ВЫБРАТЬ
	               |	СУММА(1) КАК КоличествоЗадач,
	               |	СУММА(ВЫБОР
	               |			КОГДА бит_уп_Задача.Состояние = ЗНАЧЕНИЕ(Справочник.бит_СтатусыОбъектов.Задача_Выполнена)
	               |				ТОГДА 1
	               |			ИНАЧЕ 0
	               |		КОНЕЦ) КАК КоличествоВыполненныхЗадач,
	               |	СУММА(ВЫБОР
	               |			КОГДА бит_уп_Задача.Состояние = ЗНАЧЕНИЕ(Справочник.бит_СтатусыОбъектов.Задача_Остановлена)
	               |				ТОГДА 1
	               |			ИНАЧЕ 0
	               |		КОНЕЦ) КАК КоличествоОстановленныхЗадач,
	               |	СУММА(ВЫБОР
	               |			КОГДА бит_уп_Задача.Состояние = ЗНАЧЕНИЕ(Справочник.бит_СтатусыОбъектов.Задача_Создана)
	               |					ИЛИ бит_уп_Задача.Состояние = ЗНАЧЕНИЕ(Справочник.бит_СтатусыОбъектов.Задача_Принята)
	               |				ТОГДА 1
	               |			ИНАЧЕ 0
	               |		КОНЕЦ) КАК КоличествоАктивныхЗадач,
	               |	СУММА(ВЫБОР
	               |			КОГДА бит_уп_Задача.СрокИсполнения <> ДАТАВРЕМЯ(1, 1, 1)
	               |					И (НЕ бит_уп_Задача.Выполнена)
	               |				ТОГДА ВЫБОР
	               |						КОГДА бит_уп_Задача.ДатаОкончанияИсполнения <> ДАТАВРЕМЯ(1, 1, 1)
	               |								И бит_уп_Задача.ДатаОкончанияИсполнения > бит_уп_Задача.СрокИсполнения
	               |							ТОГДА 1
	               |						КОГДА бит_уп_Задача.ДатаОкончанияИсполнения = ДАТАВРЕМЯ(1, 1, 1)
	               |								И &ТекущаяДата > бит_уп_Задача.СрокИсполнения
	               |							ТОГДА 1
	               |						ИНАЧЕ 0
	               |					КОНЕЦ
	               |			ИНАЧЕ 0
	               |		КОНЕЦ) КАК КоличествоНезавершенныхПросроченныхЗадач
	               |ИЗ
	               |	Задача.бит_уп_Задача КАК бит_уп_Задача
	               |ГДЕ
	               |	бит_уп_Задача.БизнесПроцесс = &Процесс";
				   
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	
	// Заполнение показателей дерева
	ПоказателиКолич = Новый Структура;
	ПоказателиКолич.Вставить("КоличествоЗадач", КонструкторСтруктурыЗначения(НСтр("ru = 'Общее количество задач'"), 0));
	ПоказателиКолич.Вставить("КоличествоАктивныхЗадач", КонструкторСтруктурыЗначения(НСтр("ru = 'Количество активных задач'"), 0));	
	ПоказателиКолич.Вставить("КоличествоВыполненныхЗадач", КонструкторСтруктурыЗначения(НСтр("ru = 'Количество выполненных задач'"), 0));
	ПоказателиКолич.Вставить("КоличествоОстановленныхЗадач", КонструкторСтруктурыЗначения(НСтр("ru = 'Количество остановленных задач'"), 0));
	ПоказателиКолич.Вставить("КоличествоНезавершенныхПросроченныхЗадач", КонструкторСтруктурыЗначения(НСтр("ru = 'Количество незавершенных задач с истекшим сроком исполнения'"), 0));
	
	Если Выборка.Следующий() Тогда
		
		Для каждого КиЗ Из ПоказателиКолич Цикл
		
			СтрЗнч = КиЗ.Значение;
			ТекЗнч = Выборка[КиЗ.Ключ];
			Если НЕ ЗначениеЗаполнено(ТекЗнч) Тогда
			
				ТекЗнч = 0;
			
			КонецЕсли; 
			СтрЗнч.Значение = ТекЗнч;
		
		КонецЦикла; 
	
	КонецЕсли; 

	// Заполнение вычисляемых показателей
	ПоказателиПроц = Новый Структура;
	ТекЗнч = ?(ПоказателиКолич.КоличествоЗадач.Значение = 0, 0, Окр(100*ПоказателиКолич.КоличествоВыполненныхЗадач.Значение/ПоказателиКолич.КоличествоЗадач.Значение,2));
	ПоказателиПроц.Вставить("ПроцентЗавершения", КонструкторСтруктурыЗначения(НСтр("ru = 'Процент завершения'"), ТекЗнч));
	ТекЗнч = ?(ПоказателиКолич.КоличествоЗадач.Значение = 0, 0, Окр(100*ПоказателиКолич.КоличествоНезавершенныхПросроченныхЗадач.Значение/ПоказателиКолич.КоличествоЗадач.Значение,2));
	ПоказателиПроц.Вставить("ПроцентНезавершенныхПросроченныхЗадач", КонструкторСтруктурыЗначения(НСтр("ru = 'Процент незавершенных задач с истекшим сроком исполнения'"), ТекЗнч));
	
	
	// Заполнение дерева
	СтрокаДереваВерх = ДобавитьСтрокуДерева(ДеревоДанных, НСтр("ru = 'Количественные показатели'"),, Истина);
	
	Для каждого КиЗ Из ПоказателиКолич Цикл
		
		СтрЗнч = КиЗ.Значение;	
		ДобавитьСтрокуДерева(СтрокаДереваВерх, СтрЗнч.Представление, СтрЗнч.Значение);
		
	КонецЦикла; 
	
	СтрокаДереваВерх = ДобавитьСтрокуДерева(ДеревоДанных, НСтр("ru = 'Процентные показатели'"),, Истина);
	
	Для каждого КиЗ Из ПоказателиПроц Цикл
		
		СтрЗнч = КиЗ.Значение;	
		ДобавитьСтрокуДерева(СтрокаДереваВерх, СтрЗнч.Представление, СтрЗнч.Значение);
		
	КонецЦикла; 
	
	Возврат ДеревоДанных;
	
КонецФункции // СформироватьДеревоДанных()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура осуществляет вывод дерева данных в табличный документ. 
// 
Процедура ВывестиДерево(ТД, ОблСтрокаГруппа, ОблСтрока, СтрокаВерх)
	
	Отступ = "    ";
	
	Для каждого СтрокаДерева Из СтрокаВерх.Строки Цикл
		
		Если СтрокаДерева.ЭтоГруппа Тогда
			
			ОблСтрокаГруппа.Параметры.ИмяПараметра = СтрокаДерева.Имя;
			ОблСтрокаГруппа.Параметры.ЗначениеПараметра = СтрокаДерева.Значение;
			
			ТД.Вывести(ОблСтрокаГруппа,0);
			
		Иначе	
			
			ОблСтрока.Параметры.ИмяПараметра = Отступ + СтрокаДерева.Имя;
			ОблСтрока.Параметры.ЗначениеПараметра = СтрокаДерева.Значение;
			
			ТД.Вывести(ОблСтрока,1);
			
		КонецЕсли; 
		
		ВывестиДерево(ТД, ОблСтрокаГруппа, ОблСтрока, СтрокаДерева);
		
	КонецЦикла; 
	
КонецПроцедуры // ВывестиДерево()
    
// Функция-конструктор структуры, хранящей представление и значение показателя процесса.
// 
// Параметры:
//  Представление - Строка.
//  Значение      - Строка.
// 
// Возвращаемое значение:
//  Структ - Структура.
// 
Функция КонструкторСтруктурыЗначения(Представление, Значение)

	Структ = Новый Структура("Представление, Значение", Представление, Значение);
	
	Возврат Структ;
	
КонецФункции // КонструкторСтруктурыЗначения()

// Процедура добавляет строку дерева. 
// 
// Параметры:
//  СтрокаВерх  - СтрокаДереваЗначений, ДеревоЗначений.
//  Имя         - Строка.
//  Значение    - Произвольный.
//  флЭтоГруппа - Булево.
// 
Функция ДобавитьСтрокуДерева(СтрокаВерх, Имя, Значение = Неопределено, флЭтоГруппа = Ложь)

	СтрокаДерева = СтрокаВерх.Строки.Добавить();
	СтрокаДерева.Имя = Имя;
	СтрокаДерева.Значение = Значение;
	СтрокаДерева.ЭтоГруппа = флЭтоГруппа;

	Возврат СтрокаДерева;
	
КонецФункции // ДобавитьСтрокуДерева()

#КонецОбласти

#КонецЕсли
