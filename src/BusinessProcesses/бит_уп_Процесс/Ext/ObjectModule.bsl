#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 
	
	Если ПометкаУдаления <> Ссылка.ПометкаУдаления Тогда
		ДополнительныеСвойства.Вставить("СинхронизироватьПометку");
		Возврат;
	КонецЕсли; 
	
	Результат = Справочники.бит_уп_Алгоритмы.АлгоритмГотовКРаботе(Алгоритм);
	Если НЕ Результат Тогда
		Сообщения = ПолучитьСообщенияПользователю(Истина);
		ОбщегоНазначения.СообщитьПользователю(Нстр("ru = 'Алгоритм не готов к использованию в процессе.'"), ЭтотОбъект,,, Отказ); 
		Для каждого Сообщение Из Сообщения Цикл
			Сообщение.Сообщить();		
		КонецЦикла; 
	КонецЕсли;

	// Определение и установка состояния процесса.
	НовСостояние = НовоеСостояние();
	
	Если НЕ НовСостояние = Состояние Тогда
		Состояние = НовСостояние;
		ДополнительныеСвойства.Вставить("ИзмененоСостояние", Истина);
	КонецЕсли; 
	
	// Запись некоторых параметров в реквизиты процесса.
	ФиксПоля = ФиксированныеПоля();
	
	Для каждого ИмяПоля Из ФиксПоля Цикл
		СтрОтбор = Новый Структура("Имя", ИмяПоля);
		МассивСтрок = ПараметрыПроцесса.НайтиСтроки(СтрОтбор);
		Если МассивСтрок.Количество() > 0 Тогда
			ПерваяСтрока = МассивСтрок[0];
			ЭтотОбъект[ИмяПоля] = ПерваяСтрока.Значение;
		Иначе
			ЭтотОбъект[ИмяПоля] = Неопределено;
		КонецЕсли; 
	КонецЦикла; // ФиксПоля
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);	
		Если ЗначениеЗаполнено(Алгоритм) Тогда
			ЗаполнитьПоАлгоритму(Алгоритм);
		КонецЕсли; 
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.бит_уп_Алгоритмы") Тогда 
		ЗаполнитьПоАлгоритму(ДанныеЗаполнения);
	КонецЕсли; 
	
	Автор = Пользователи.ТекущийПользователь();
	Режим = Перечисления.бит_уп_РежимыПроцессов.Обычный;
	РежимАдресацииАвтоматическихЗадач = Перечисления.бит_уп_РежимыАдресацииАвтоматическихЗадач.Исполнитель;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Состояние = Справочники.бит_СтатусыОбъектов.ПустаяСсылка();
	Автор     = бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь");	
	ДатаНачалаИсполнения    = Дата('00010101');
	ДатаОкончанияИсполнения = Дата('00010101');
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если НЕ Отказ Тогда
		
		флИзмененоСостояние = Ложь;
		ДополнительныеСвойства.Свойство("ИзмененоСостояние", флИзмененоСостояние);
		
		Если флИзмененоСостояние = Истина Тогда
			
			// Сохранение истории изменения состояний
			СохранитьИсторию();
			ДополнительныеСвойства.Вставить("ИзмененоСостояние", Ложь);
			
			ВыполнитьРегистрациюСобытийДляОповещений(Отказ);
			
		КонецЕсли; 
		
		Если ДополнительныеСвойства.Свойство("Остановить") Тогда
			
			// Остановка задач процесса
			БизнесПроцессы.бит_уп_Процесс.ОстановитьЗадачиПроцесса(Ссылка, "Ошибки");
			ДополнительныеСвойства.Удалить("Остановить");
			
		КонецЕсли; 
		
		Если ДополнительныеСвойства.Свойство("Продолжить") Тогда
			
			// Отмена остановки задач процесса
			БизнесПроцессы.бит_уп_Процесс.ПродолжитьЗадачиПроцесса(Ссылка, "Ошибки");
			ДополнительныеСвойства.Удалить("Продолжить");			
			
		КонецЕсли; 
		
		Если ДополнительныеСвойства.Свойство("СинхронизироватьПометку") Тогда
			
			 // Выполнение синхронизации пометки удаления у задач.
			 ТабЗадачи = БизнесПроцессы.бит_уп_Процесс.ПолучитьЗадачиПроцесса(Ссылка);
			 
			 Для каждого СтрокаТаблицы ИЗ ТабЗадачи Цикл
			 
				бит_ОбщегоНазначения.ИзменитьПометкуНаУдалениеУОбъекта(СтрокаТаблицы.Задача
																		  ,ПометкаУдаления
																		  ,
																		  ,"Ошибки"
																		  ,Новый Структура("ОшибкуПодробно"));
																		  
																		  
																		  
			 КонецЦикла; // ТабЗадачи
			 
			 ДополнительныеСвойства.Удалить("СинхронизироватьПометку");			
			 
		КонецЕсли;  // ДополнительныеСвойства.Свойство("СинхронизироватьПометку").
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	Если ЗначениеЗаполнено(Алгоритм.Префикс) Тогда
	
		Префикс = Алгоритм.Префикс;
	
	КонецЕсли; 
	
КонецПроцедуры // ПриУстановкеНовогоНомера()

#Область ОбработчикиТочекБизнесПроцесса

// Процедура - обработчик события "ПередСтартом" точки бизнес-процесса "Старт".
// 
Процедура СтартПередСтартом(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	// Проверка заполнения обязательных параметров.
	бит_уп_Сервер.ПроверитьЗаполнениеПараметровПроцесса(ПараметрыПроцесса, Отказ);
	
	Если НЕ Отказ Тогда
		
		// В режиме перезапуска отменяем проведение документов, прикрепленных к задачам.
		Если Режим = Перечисления.бит_уп_РежимыПроцессов.Перезапуск Тогда
		
			 ТабЗадачи = БизнесПроцессы.бит_уп_Процесс.ПолучитьЗадачиПроцесса(ПроцессОснование);
			 
			 Для каждого СтрокаТаблицы Из ТабЗадачи Цикл
			 
			 	 ТекПредмет = СтрокаТаблицы.Задача.Предмет;
				 
				 Если ЗначениеЗаполнено(ТекПредмет) Тогда
				 
				 	МетаПредмет = ТекПредмет.Метаданные();
					Имена = бит_ОбщегоНазначенияКлиентСервер.РазобратьПолноеИмяОбъекта(МетаПредмет.ПолноеИмя());
					
					Если Имена.ИмяКласса = "Документ" И ТекПредмет.Проведен Тогда
					
						 ПредметОбъект = ТекПредмет.ПолучитьОбъект();
						 // Без попытки - т.к. в транзакции уже
						 ПредметОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
					
					КонецЕсли; 
					
				 КонецЕсли; 
			 
			 КонецЦикла; 
		
		КонецЕсли; //Перезапуск
		
		ДатаНачалаИсполнения = ТекущаяДата();
		
		Если ЗначениеЗаполнено(ВедущаяЗадача) Тогда
		
			 Задачи.бит_уп_Задача.ПринятьЗадачу(ВедущаяЗадача);
		
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

// Процедура - обработчик события "ПередСозданиемЗадач" 
// точки бизнес-процесса "ВыполнениеДействий".
// 
Процедура ВыполнениеДействийПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	БизнесПроцессы.бит_уп_Процесс.СоздатьЗадачиПроцесса(ЭтотОбъект, ФормируемыеЗадачи);
	ДополнительныеСвойства.Вставить("КоличествоНовыхЗадач", ФормируемыеЗадачи.Количество());

КонецПроцедуры

// Процедура - обработчик события "ПроверкаУсловия" точки бизнес-процесса "ПродолжитьВыполнение".
// 
Процедура ПродолжитьВыполнениеПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Если ДополнительныеСвойства.Свойство("КоличествоНовыхЗадач") Тогда
		КоличествоНовыхЗадач = ДополнительныеСвойства.КоличествоНовыхЗадач;
	Иначе	
		// После выполнения задачи сразу вызывается проверка условия, и неизвестно будут ли созданы новые задачи или нет.
		// Поэтому принудительно ставим КоличествоНовыхЗадач = 1, 
		// чтобы передать управление в обработчик ВыполнениеДействийПередСозданиемЗадач().
		// Если в обработчике новые задачи не будут сформированы, то тогда процесс будет завершен.
		КоличествоНовыхЗадач = 1;
	КонецЕсли; 
	
	// Продолжать или нет процесс, результат = ложь приводит к завершению процесса.
	Результат = КоличествоНовыхЗадач > 0 ИЛИ БизнесПроцессы.бит_уп_Процесс.ЕстьНевыполненныеЗадачи(ЭтотОбъект.Ссылка);

КонецПроцедуры

// Процедура - обработчик события "ПриЗавершении" точки бизнес-процесса "Заверешение".
// 
Процедура ЗавершениеПриЗавершении(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	Если НЕ Отказ Тогда
		
		ДатаОкончанияИсполнения = ТекущаяДата();
		Состояние = Справочники.бит_СтатусыОбъектов.Процесс_Завершен;
		СохранитьИсторию();
		
	КонецЕсли; 	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
 
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоАлгоритму(ДанныеЗаполнения)

	БизнесПроцессы.бит_уп_Процесс.ЗаполнитьПоАлгоритму(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры

Функция НовоеСостояние()
	
	Если Состояние = Справочники.бит_СтатусыОбъектов.Процесс_Остановлен Тогда
		НовоеСостояние = Справочники.бит_СтатусыОбъектов.Процесс_Остановлен;
	ИначеЕсли Завершен Тогда
		НовоеСостояние = Справочники.бит_СтатусыОбъектов.Процесс_Завершен;
	ИначеЕсли Стартован Тогда
		НовоеСостояние = Справочники.бит_СтатусыОбъектов.Процесс_Активный;
	Иначе	 
		НовоеСостояние = Справочники.бит_СтатусыОбъектов.Процесс_Записан;
	КонецЕсли; 	
	
	Если ДополнительныеСвойства.Свойство("Остановить") Тогда
		НовоеСостояние = Справочники.бит_СтатусыОбъектов.Процесс_Остановлен;
	КонецЕсли; 
	
	Если ДополнительныеСвойства.Свойство("Продолжить") Тогда
		НовоеСостояние = Справочники.бит_СтатусыОбъектов.Процесс_Активный;
	КонецЕсли; 
	
	Возврат НовоеСостояние;
	
КонецФункции
 
// Функция возвращает массив имен параметров, которые следует 
// синхронизировать перед записью с соответсвующими реквизитами Бизнес-Процесса.
// 
// Возвращаемое значение:
//  ФиксПоля - Массив.
// 
Функция ФиксированныеПоля()

	ФиксПоля = Новый Массив;
	ФиксПоля.Добавить("Организация");
	ФиксПоля.Добавить("ЦФО");
	ФиксПоля.Добавить("Проект");
	ФиксПоля.Добавить("Сценарий");

	Возврат ФиксПоля;
	
КонецФункции

Процедура СохранитьИсторию()
	
	// Сохраним историю изменения статуса
	МенеджерЗаписи = РегистрыСведений.бит_ИсторияИзмененияСтатусовОбъектов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Объект       = Ссылка;
	МенеджерЗаписи.Период       = ТекущаяДата();
	МенеджерЗаписи.ВидСтатуса   = Перечисления.бит_ВидыСтатусовОбъектов.Статус;
	МенеджерЗаписи.Пользователь = бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь");
	МенеджерЗаписи.Статус       = Состояние;
	Попытка
		МенеджерЗаписи.Записать();
	Исключение
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось сохранить историю изменения статуса процесса ""%1"". По причине: %2'"), 
			Ссылка, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект); 
	КонецПопытки;
	
КонецПроцедуры // СохранитьИсторию()

// Процедура выполняет регистрацию событий для оповещений.
// 
// Параметры:
// 	Отказ - булево - отказ от записи объекта.
// 
Процедура ВыполнитьРегистрациюСобытийДляОповещений(Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("бит_ИспользоватьМеханизмОповещений") Тогда
		Возврат;	
	КонецЕсли;
	
	ТаблицаОповещений = бит_ОбщиеПеременныеСервер.ЗначениеПеременной("бит_фн_АктивныеОповещения");
	
	// Обработаем события
	Если НЕ ТаблицаОповещений = Неопределено И НЕ ДополнительныеСвойства.Свойство("бит_ОтключитьРегистрациюОповещений") Тогда
		
		// Определим объект системы по метаданным
		ОбъектСистемы = бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(ЭтотОбъект.Метаданные());
		ВидСобытия 	  = Перечисления.бит_фн_ВидыСобытийОповещений.ИзмененоСостояниеПроцесса;
		
		// Получим оповещения данного вида для данного объекта.
		Отбор 	  = Новый Структура("ВидСобытия,ОбъектСистемы",ВидСобытия,ОбъектСистемы);
		Результат = ТаблицаОповещений.НайтиСтроки(Отбор);							
		
		Для Каждого СтрокаОповещения Из Результат Цикл
			
			// Проверим "быстрые" условия
			АлгоритмПроцессаСоответствует = Ложь;
			СостояниеСоответствует		= Ложь;
			
			// Проверим алгоритм
			Если НЕ ЗначениеЗаполнено(СтрокаОповещения.АлгоритмПроцесса) Тогда
				АлгоритмПроцессаСоответствует = Истина;
			ИначеЕсли СтрокаОповещения.АлгоритмПроцесса = Алгоритм Тогда
				АлгоритмПроцессаСоответствует = Истина;
			КонецЕсли;
			
			// Проверим состояние
			Если НЕ ЗначениеЗаполнено(СтрокаОповещения.Статус) Тогда
				СостояниеСоответствует = Истина;
			ИначеЕсли СтрокаОповещения.Статус = Состояние Тогда
				СостояниеСоответствует = Истина;
			КонецЕсли;
			
			Соответствует = АлгоритмПроцессаСоответствует И СостояниеСоответствует;
			
			// Если задано пользовательское условие, проверим его.
			Если Соответствует И ЗначениеЗаполнено(СтрокаОповещения.ПользовательскоеУсловие) Тогда
				СтруктураКонтекст = Новый Структура("ТекущийОбъект",ЭтотОбъект);
				Соответствует = бит_уп_Сервер.ПроверитьПользовательскоеУсловие(
									СтрокаОповещения.ПользовательскоеУсловие, СтруктураКонтекст);
			КонецЕсли;
																			 
			Если Соответствует Тогда
				ЗарегистрироватьСобытиеДляОповещений(ВидСобытия,СтрокаОповещения.Оповещение,ЭтотОбъект);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Процедура регистрирует событие в регистре сведений бит_фн_РегистрацияСобытийОповещений 
// для последующей обработки и создания оповещений.
// 
// Параметры:
//  ВидСобытия  - ПеречислениеСсылка.бит_фн_ВидыСобытийОповещений
//  Оповещение  - СправочникСсылка.бит_фн_Оповещения
//  ИсточникСсылка  - СправочникСсылка, ДокументСсылка.
// 
Процедура ЗарегистрироватьСобытиеДляОповещений(ВидСобытия,Оповещение,ПроцессОбъект)
	
	бит_фн_ОповещенияСервер.ЗарегистрироватьСобытиеДляОповещений(ВидСобытия, Оповещение, ПроцессОбъект.Ссылка,,,
		ПроцессОбъект.Состояние);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
