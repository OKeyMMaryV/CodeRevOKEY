//{bit_SVKushnirenko 06.03.2017 #2596
//Возвращает представление условия по параметрам
// Параметры:
//парВидАналитики - строковое представиление вида аналитики, которое будет возвращено
//парУсловие - тип условия пчс.бит_БК_УсловияЗначения
//парЗначение - правое значение условия
&НаСервереБезКонтекста
Функция ПолучитьПредставлениеУсловия(парВидАналитики, парУсловие, парЗначение)

	Если парУсловие = Перечисления.бит_БК_УсловияЗначения.КлАн Тогда  
		
		Возврат "" + парВидАналитики + " = КлАн";
	ИначеЕсли парУсловие = Перечисления.бит_БК_УсловияЗначения.Любое Тогда 
		
		Возврат "ꓯ " + парВидАналитики;
	ИначеЕсли парУсловие = Перечисления.бит_БК_УсловияЗначения.НеРавно Тогда 
		
		Возврат "" + парВидАналитики + " ≠ " + парЗначение;
	ИначеЕсли парУсловие = Перечисления.бит_БК_УсловияЗначения.Равно Тогда 
		
		Возврат "" + парВидАналитики + " = " + парЗначение;
	Иначе
		
		Возврат " ";
	КонецЕсли;
КонецФункции // ПолучитьПредставлениеУсловия() }bit_SVKushnirenko 06.03.2017 #2596 

//{bit_SVKushnirenko 06.03.2017 #2596
&НаКлиенте
Функция СписокАтрибутовДляУправленияУсловиямиШапки()

	Возврат  Новый Структура("ЦФО, СтатьяОборотов, Аналитика_2, Регион, Проект", 
	"ЦФО",
	"Статья оборотов", 
	"Объект", 
	"Регион", 
	"Проект"); 
КонецФункции // СписокАтрибутовДляУправленияУсловиямиШапки() }bit_SVKushnirenko 06.03.2017 #2596 

//{bit_SVKushnirenko 09.03.2017 #2596
//Строит очередную порцию представления в соответствии с текущими данными строки представления и значения порции соответствия
// Параметры:
//парСтрокаПредставления - строка представления, куда будет помещена очередная секция из соответствия 
//парЗначениеСоответствия - значение соответствия (значения для вида условия)
//парВидУсловия - вид условия, для формирования правильного выражения "равно" и "не равно"
&НаКлиенте
Функция СоответствиеПоПредставленияУсловию(парСтрокаПредставления, парСоответствие, парВидУсловия)

	пЗначениеИзСоответствия = СокрЛП(парСоответствие[парВидУсловия]);
	Если СокрЛП(пЗначениеИзСоответствия) = "" Тогда  
		
		Возврат парСтрокаПредставления;
	КонецЕсли;

	Если парВидУсловия = ПредопределенноеЗначение("Перечисление.бит_БК_УсловияЗначения.Равно") или
		парВидУсловия = ПредопределенноеЗначение("Перечисление.бит_БК_УсловияЗначения.НеРавно") Тогда //вывод значения в представление

		Возврат  парСтрокаПредставления + ?(парСтрокаПредставления = "", "", " и ") + пЗначениеИзСоответствия;
	Иначе

		Возврат  парСтрокаПредставления + ?(парСтрокаПредставления = "", "", " и ") + СокрЛП(парВидУсловия) + " " + пЗначениеИзСоответствия;
	КонецЕсли;
КонецФункции // СоответствиеПоПредставленияУсловию() }bit_SVKushnirenko 09.03.2017 #2596


//{bit_SVKushnirenko 06.03.2017 #2596
//Возвращает представление условий по данным правил в ТЧ
&НаКлиенте
Функция ПредставлениеУсловийПоТЧ(парИмяТЧОбъекта, парРежимНаименования = Истина)
	
	пСписокАтрибутов = СписокАтрибутовДляУправленияУсловиямиШапки();
	
	пТекстПредставления = "";
	Для каждого пСтрокаУсловия Из Объект[парИмяТЧОбъекта] Цикл
	
		//Инициализация хранения по видам условий
		пСоответствиеПоВидамУсловий = Новый Соответствие;
		
		//ПС в зависимости от режима (наименование, представление на форме)
		Если парРежимНаименования Тогда  
			
			пКлючевойСимвол = " ";
		Иначе
			
			пКлючевойСимвол = Символы.ПС;
		КонецЕсли;
		
		//Выбор узначений  по видам условий для поля
		Для каждого пЭлемент Из пСписокАтрибутов Цикл
			
			пКлюч = пЭлемент.Ключ;
			пСиноним = пЭлемент.Значение;
			
			
			пУсловие = пСтрокаУсловия[пКлюч + "_Условие"];
			пЗначение = пСтрокаУсловия[пКлюч + "_Значение"];
			
			пСтрокаАтрибутов = СокрЛП(пСоответствиеПоВидамУсловий[пУсловие]);
			пСтрокаАтрибутов = пСтрокаАтрибутов + ?(пСтрокаАтрибутов = "", "", ", ") + пСиноним;
			
			Если пУсловие = ПредопределенноеЗначение("Перечисление.бит_БК_УсловияЗначения.Равно") или
				пУсловие = ПредопределенноеЗначение("Перечисление.бит_БК_УсловияЗначения.НеРавно") Тогда //вывод значения в представление
				
				пСтрокаАтрибутов = пСтрокаАтрибутов + " " + пУсловие + " """ + пЗначение + """";
			КонецЕсли;
			
			пСоответствиеПоВидамУсловий.Вставить(пУсловие, пСтрокаАтрибутов);
		КонецЦикла; 
		
		//Компоновка представления по видам условий
		 
		Если пТекстПредставления <> "" и Прав(пТекстПредставления, 1) <> пКлючевойСимвол Тогда  
			
			пТекстПредставления = пТекстПредставления + пКлючевойСимвол;
		КонецЕсли;
		
		пТекстПредставления = пТекстПредставления + СокрЛП(пСтрокаУсловия.ГруппЛев);

		пЛокальноеПредставлениеСтроки = "";
		пЛокальноеПредставлениеСтроки = СоответствиеПоПредставленияУсловию(пЛокальноеПредставлениеСтроки, пСоответствиеПоВидамУсловий, ПредопределенноеЗначение("Перечисление.бит_БК_УсловияЗначения.Любое"));
		пЛокальноеПредставлениеСтроки = СоответствиеПоПредставленияУсловию(пЛокальноеПредставлениеСтроки, пСоответствиеПоВидамУсловий, ПредопределенноеЗначение("Перечисление.бит_БК_УсловияЗначения.КлАн"));
		пЛокальноеПредставлениеСтроки = СоответствиеПоПредставленияУсловию(пЛокальноеПредставлениеСтроки, пСоответствиеПоВидамУсловий, ПредопределенноеЗначение("Перечисление.бит_БК_УсловияЗначения.Равно"));
		пЛокальноеПредставлениеСтроки = СоответствиеПоПредставленияУсловию(пЛокальноеПредставлениеСтроки, пСоответствиеПоВидамУсловий, ПредопределенноеЗначение("Перечисление.бит_БК_УсловияЗначения.НеРавно"));
		
		пТекстПредставления = пТекстПредставления + пЛокальноеПредставлениеСтроки + СокрЛП(пСтрокаУсловия.ГруппПрав) + ?(СокрЛП(пСтрокаУсловия.ОператорСледующего) = "", "", " " + пСтрокаУсловия.ОператорСледующего + " ") ;
	КонецЦикла; 
	
	Если Прав(пТекстПредставления, 3) = " И " Тогда //очистка некорректного завершения условия 
		
		пТекстПредставления = Лев(пТекстПредставления, СтрДлина(пТекстПредставления) - 3);
	ИначеЕсли Прав(пТекстПредставления, 5) = " ИЛИ "  Тогда
		
		пТекстПредставления = Лев(пТекстПредставления, СтрДлина(пТекстПредставления) - 5);
	КонецЕсли;

	Возврат пТекстПредставления;
КонецФункции // ПредставлениеУсловийПоТЧ() }bit_SVKushnirenko 06.03.2017 #2596

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	//Формирование представления условия
	Объект.Наименование = ПредставлениеУсловийПоТЧ("тбчУсловиеПолучателя", Истина);
	
	//Проверка корректности данных ТЧ
	пЛевСкобки = 0;
	пПрвСкобки = 0;
	Для каждого пСтрока Из Объект.тбчУсловиеПодбораИсточников Цикл
	
		пДлинаЛев = СтрДлина(пСтрока.ГруппЛев) - СтрДлина(СтрЗаменить(пСтрока.ГруппЛев, "(", ""));
		пДлинаПрв = СтрДлина(пСтрока.ГруппПрав) - СтрДлина(СтрЗаменить(пСтрока.ГруппПрав, ")", ""));
		
		пЛевСкобки = пЛевСкобки + пДлинаЛев;
		пПрвСкобки = пПрвСкобки + пДлинаПрв;
	КонецЦикла; 
	
	Если пЛевСкобки <>  пПрвСкобки Тогда  
		
		Отказ = Истина;
		Сообщить("У условии подбора данных источника, количество скобок ""("", не равно количеству скобок "")"" - сохраниение условия невозможно до исправления данных!");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура тбчУсловиеПодбораИсточниковПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда  
		
		пСписокАтрибутов = СписокАтрибутовДляУправленияУсловиямиШапки();
		Для каждого пЭлемент Из пСписокАтрибутов Цикл
			
			Элемент.ТекущиеДанные[пЭлемент.Ключ + "_Условие"] = ПредопределенноеЗначение("Перечисление.бит_БК_УсловияЗначения.Любое");
		КонецЦикла; 
	КонецЕсли;
КонецПроцедуры

//{bit_SVKushnirenko 06.03.2017 #2596
//Выполняет контроль и установку доступности реквизита-значения, по данным реквизита-условия
// Параметры:
//парИмяРеквизитаУсловия - строка-имя реквизита условия (по которому можно прочитать его значение) 
//парИмяРеквизитаЗначения - строка-имя реквизита значения по которому можно записать его значение
//парТабличнаяЧасть - строка-имя реквизита формы "табличная часть", которой может принадлежать реквизит-значение для которого изменяется поведение доступности
&НаКлиенте
Функция ПриИзмененииРеквизитаУсловия(парИмяРеквизитаУсловия, парИмяРеквизитаЗначения, парТабличнаяЧасть = "")

	Если парТабличнаяЧасть = "" Тогда  
		
		пЗначениеУсловия = Объект[парИмяРеквизитаУсловия];
	Иначе
		
		пТекущиеДанные = Элементы[парТабличнаяЧасть].ТекущиеДанные;
		Если пТекущиеДанные = Неопределено Тогда  
			
			Возврат "";
		КонецЕсли;
		 
		пЗначениеУсловия = пТекущиеДанные[парИмяРеквизитаУсловия];
	КонецЕсли;
		
	Если пЗначениеУсловия = ПредопределенноеЗначение("Перечисление.бит_БК_УсловияЗначения.КлАн") или
		пЗначениеУсловия = ПредопределенноеЗначение("Перечисление.бит_БК_УсловияЗначения.Любое") Тогда  
		
		//Очистка значения условия, если оно недоступно
		Если парТабличнаяЧасть = "" Тогда  
			
			пЗначение = Объект[парИмяРеквизитаЗначения];
			Если ЗначениеЗаполнено(пЗначение) Тогда  
				
				Объект[парИмяРеквизитаЗначения] = Неопределено;	
			КонецЕсли;
		Иначе
			
			пЗначение = Элементы[парТабличнаяЧасть].ТекущиеДанные[парИмяРеквизитаЗначения];
			Если ЗначениеЗаполнено(пЗначение) Тогда  

				Элементы[парТабличнаяЧасть].ТекущиеДанные[парИмяРеквизитаЗначения] = Неопределено
			КонецЕсли;
		КонецЕсли;
		ЭтаФорма.Элементы[парТабличнаяЧасть + парИмяРеквизитаЗначения].ТолькоПросмотр = Истина;
	Иначе
		
		ЭтаФорма.Элементы[парТабличнаяЧасть + парИмяРеквизитаЗначения].ТолькоПросмотр = Ложь;
	КонецЕсли;
КонецФункции // ПриИзмененииРеквизитаУсловия() }bit_SVKushnirenko 06.03.2017 #2596

&НаКлиенте
Процедура тбчУсловиеПодбораИсточниковЦФО_УсловиеПриИзменении(Элемент)
	
	ПриИзмененииУсловияУниверсальныйОбработчик("ЦФО", "тбчУсловиеПодбораИсточников");
КонецПроцедуры

&НаКлиенте
Процедура тбчУсловиеПодбораИсточниковСтатьяОборотов_УсловиеПриИзменении(Элемент)

	ПриИзмененииУсловияУниверсальныйОбработчик("СтатьяОборотов", "тбчУсловиеПодбораИсточников");
КонецПроцедуры

&НаКлиенте
Процедура тбчУсловиеПодбораИсточниковАналитика2_УсловиеПриИзменении(Элемент)

	ПриИзмененииУсловияУниверсальныйОбработчик("Аналитика_2", "тбчУсловиеПодбораИсточников");
КонецПроцедуры

&НаКлиенте
Процедура тбчУсловиеПодбораИсточниковРегион_УсловиеПриИзменении(Элемент)

	ПриИзмененииУсловияУниверсальныйОбработчик("Регион", "тбчУсловиеПодбораИсточников");
КонецПроцедуры

&НаКлиенте
Процедура тбчУсловиеПодбораИсточниковПроект_УсловиеПриИзменении(Элемент)

	ПриИзмененииУсловияУниверсальныйОбработчик("Проект", "тбчУсловиеПодбораИсточников");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//Формируем представления условий
	рекПредставленияПолучателя = ПредставлениеУсловийПоТЧ("тбчУсловиеПолучателя", Ложь);
	рекПредставленияИсточника = ПредставлениеУсловийПоТЧ("тбчУсловиеПодбораИсточников", Ложь);
КонецПроцедуры

&НаКлиенте
Процедура тбчУсловиеПоЛучателяПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	Если НоваяСтрока Тогда  
		
		пСписокАтрибутов = СписокАтрибутовДляУправленияУсловиямиШапки();
		Для каждого пЭлемент Из пСписокАтрибутов Цикл
			
			Элемент.ТекущиеДанные[пЭлемент.Ключ + "_Условие"] = ПредопределенноеЗначение("Перечисление.бит_БК_УсловияЗначения.Любое");
		КонецЦикла; 
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
//{bit_SVKushnirenko 07.03.2017 #2596
//Обработчик изменения условия отбора
// Параметры:
//парИмяАналитики - строка имя аналитики (ЦФО, Проект, СтатьяОборотов...)
//парИмяРеквизитаТабличнойЧасти - строка имя реквизита табличной части
Функция ПриИзмененииУсловияУниверсальныйОбработчик(парИмяАналитики, парИмяРеквизитаТабличнойЧасти)

	ПриИзмененииРеквизитаУсловия(парИмяАналитики + "_Условие", парИмяАналитики + "_Значение", парИмяРеквизитаТабличнойЧасти);
КонецФункции // ПриИзмененииУсловияУниверсальныйОбработчик() }bit_SVKushnirenko 07.03.2017 #2596

&НаКлиенте
Процедура тбчУсловиеПоЛучателяЦФО_УсловиеПриИзменении(Элемент)

	ПриИзмененииУсловияУниверсальныйОбработчик("ЦФО", "тбчУсловиеПоЛучателя");
КонецПроцедуры

&НаКлиенте
Процедура тбчУсловиеПоЛучателяСтатьяОборотов_УсловиеПриИзменении(Элемент)

	ПриИзмененииУсловияУниверсальныйОбработчик("СтатьяОборотов", "тбчУсловиеПоЛучателя");
КонецПроцедуры

&НаКлиенте
Процедура тбчУсловиеПоЛучателяАналитика_2_УсловиеПриИзменении(Элемент)

	ПриИзмененииУсловияУниверсальныйОбработчик("Аналитика_2", "тбчУсловиеПоЛучателя");
КонецПроцедуры

&НаКлиенте
Процедура тбчУсловиеПоЛучателяРегион_УсловиеПриИзменении(Элемент)

	ПриИзмененииУсловияУниверсальныйОбработчик("Регион", "тбчУсловиеПоЛучателя");
КонецПроцедуры

&НаКлиенте
Процедура тбчУсловиеПоЛучателяПроект_УсловиеПриИзменении(Элемент)

	ПриИзмененииУсловияУниверсальныйОбработчик("Проект", "тбчУсловиеПоЛучателя");
КонецПроцедуры

//{bit_SVKushnirenko 09.03.2017 #2596
//Выполняет изменения скобок при регулировании элемента
&НаКлиенте
Функция РегулированиеСкобок(парСкобка, парЗначение, парНаправление)

	пДлина = СтрДлина(СокрЛП(парЗначение));
	Возврат Лев(СтрЗаменить(Формат(1, "ЧЦ=" + (пДлина + 2) + "; ЧВН=; ЧГ=0"), "0", парСкобка), пДлина + парНаправление);
КонецФункции // РегулированиеСкобок() }bit_SVKushnirenko 09.03.2017 #2596

&НаКлиенте
Процедура тбчУсловиеПоЛучателяГруппЛевРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	Элементы.тбчУсловиеПолучателя.ТекущиеДанные.ГруппЛев = РегулированиеСкобок("(", Элементы.тбчУсловиеПолучателя.ТекущиеДанные.ГруппЛев, Направление);
КонецПроцедуры

&НаКлиенте
Процедура тбчУсловиеПоЛучателяГруппПравРегулирование(Элемент, Направление, СтандартнаяОбработка)

	Элементы.тбчУсловиеПолучателя.ТекущиеДанные.ГруппПрав = РегулированиеСкобок(")", Элементы.тбчУсловиеПолучателя.ТекущиеДанные.ГруппПрав, Направление);
КонецПроцедуры

&НаКлиенте
Процедура тбчУсловиеПодбораИсточниковГруппЛевРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	Элементы.тбчУсловиеПодбораИсточников.ТекущиеДанные.ГруппЛев = РегулированиеСкобок("(", Элементы.тбчУсловиеПодбораИсточников.ТекущиеДанные.ГруппЛев, Направление);
КонецПроцедуры

&НаКлиенте
Процедура тбчУсловиеПодбораИсточниковГруппПравРегулирование(Элемент, Направление, СтандартнаяОбработка)

	Элементы.тбчУсловиеПодбораИсточников.ТекущиеДанные.ГруппПрав = РегулированиеСкобок(")", Элементы.тбчУсловиеПодбораИсточников.ТекущиеДанные.ГруппПрав, Направление);
КонецПроцедуры

&НаКлиенте
Процедура тбчУсловиеПодбораИсточниковПриАктивизацииСтроки(Элемент)
	
	//Начальная установка доступности (значения) в условии
	пСписокАтрибутов = СписокАтрибутовДляУправленияУсловиямиШапки();
	Для каждого пЭлемент Из пСписокАтрибутов Цикл
		
		пКлюч = пЭлемент.Ключ;
		ПриИзмененииРеквизитаУсловия(пКлюч + "_Условие", пКлюч + "_Значение", "тбчУсловиеПодбораИсточников");
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура тбчУсловиеПоЛучателяПриАктивизацииСтроки(Элемент)
	
	//Начальная установка доступности (значения) в условии
	пСписокАтрибутов = СписокАтрибутовДляУправленияУсловиямиШапки();
	Для каждого пЭлемент Из пСписокАтрибутов Цикл
		
		пКлюч = пЭлемент.Ключ;
		ПриИзмененииРеквизитаУсловия(пКлюч + "_Условие", пКлюч + "_Значение", "тбчУсловиеПолучателя");
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура тбчУсловиеПоЛучателяПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)

	рекПредставленияПолучателя = ПредставлениеУсловийПоТЧ("тбчУсловиеПолучателя", Ложь);
КонецПроцедуры

&НаКлиенте
Процедура тбчУсловиеПодбораИсточниковПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)

	рекПредставленияИсточника = ПредставлениеУсловийПоТЧ("тбчУсловиеПодбораИсточников", Ложь);
КонецПроцедуры

//{bit_SVKushnirenko 16.03.2017 #2596
//Возвращает сценарий по соответствию
// Параметры:
//парСценарий - ссылка на сценарий 
//парКонтролируемый - Истина = контролируемый, Ложь = контролирующий
&НаСервереБезКонтекста
Функция ПолучитьСценарийПоПараметру(парСценарий, парКонтролируемый = Истина)

	пЗапрос = Новый Запрос;
	пТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВЫРАЗИТЬ(бит_СоответствияАналитик.ЛеваяАналитика_1 КАК Справочник.СценарииПланирования) КАК СценарийСсылка
	|ИЗ
	|	РегистрСведений.бит_СоответствияАналитик КАК бит_СоответствияАналитик
	|ГДЕ
	|	бит_СоответствияАналитик.ВидСоответствия.Код = ""бит_БК_СценарийВСценарийКонтролируемый""
	|	И бит_СоответствияАналитик.ПраваяАналитика_1 = &пзСценарийПараметр";
	
	пЗапрос.УстановитьПараметр("пзСценарийПараметр", парСценарий);
	
	Если не парКонтролируемый  Тогда  
		
		пТекстЗапроса = СтрЗаменить(пТекстЗапроса, "ВЫРАЗИТЬ(бит_СоответствияАналитик.ЛеваяАналитика_1", "ВЫРАЗИТЬ(бит_СоответствияАналитик.ПраваяАналитика_1");
		пТекстЗапроса = СтрЗаменить(пТекстЗапроса, "бит_СоответствияАналитик.ПраваяАналитика_1 = &пзСценарийПараметр", "бит_СоответствияАналитик.ЛеваяАналитика_1 = &пзСценарийПараметр");
	КонецЕсли;
	 				 
	пЗапрос.Текст = пТекстЗапроса;
		
	пТЗРез = пЗапрос.Выполнить().Выгрузить();
	
	Если пТЗРез.Количество() = 0 Тогда 
		
		Возврат Неопределено;
	Иначе
		
		Возврат пТЗРез[0].СценарийСсылка;
	КонецЕсли;
КонецФункции // ПолучитьСценарийПоПараметру() }bit_SVKushnirenko 16.03.2017 #2596 

&НаКлиенте
Процедура СценарийПриИзменении(Элемент)
	
	Объект.СценарийКонтролируемый = ПолучитьСценарийПоПараметру(Объект.Сценарий, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура СценарийКонтролируемыйПриИзменении(Элемент)
	
	Объект.Сценарий = ПолучитьСценарийПоПараметру(Объект.СценарийКонтролируемый, Истина);
КонецПроцедуры
